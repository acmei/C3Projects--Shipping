require "#{ Rails.root }/lib/shipping_api.rb"

class FedAxApiController < ApplicationController
  include FedAxApiWrapper

  def quote
    begin
      content = ShippingApi.query(shipping_quote_params)

      # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
      if content[:status] == 200
        status = :ok
      else content[:status] == 204
        status = :no_content
      end

      # handling for receiving just the shipping quote for a given service type
      if params[:shipping]
        carrier, service_type = shipping_choice_params
        shipping_details = shipping_selection(content[:quotes], carrier, service_type)

        content = {}
        content[:quote] = shipping_details
        content[:status] = 200

        status = :ok
      end

    # this is not a hash rocket. it is doing some magic thing where it's assigning
    # the error object to a variable. now we can access the error object's message
    rescue ActionController::ParameterMissing => error # this is raised by missing params
      content = { message: "#{ error.message.capitalize }" }
      status = :bad_request
    rescue ActiveShipping::ResponseError => error # this error is raised by bad address formats
      content = { message: "#{ error.message }" }
      status = :bad_request
    end

    render json: content, status: status
  end


  def ship # FIXME: this method should accept & handle for extracting a single shipping method
    begin
      content = ShippingApi.query(shipping_quote_params)

      # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
      if content[:status] == 200
        carrier, service_type = shipping_choice_params
        shipping_details = shipping_selection(content[:quotes], carrier, service_type)
        log_entry = ApiResponse.create(shipping_details)
        log_entry.log!(save_shipping_quote_params)

        content = {}
        content[:receipt] = shipping_details
        content[:status] = 201

        status = :created
      else content[:status] == 204
        status = :no_content
      end


    # this is not a hash rocket. it is doing some magic thing where it's assigning
    # the error object to a variable. now we can access the error object's message
    rescue ActionController::ParameterMissing => error
      content = { message: "#{ error.message.capitalize }" }
      status = :bad_request
    rescue ActiveShipping::ResponseError => error
      content = { message: "#{ error.message }" }
      status = :bad_request
    end

    render json: content, status: status
  end

  def root
    @last_shipped = ApiResponse.last
    render :root, layout: false
  end

  private
    def shipping_quote_params
      result = {}

      result[:packages] = params.permit("packages" => ["weight", "width", "height", "depth"])["packages"]
      result[:origin] = params.require("origin").permit("country", "state", "city", "zip")
      result[:destination] = params.require("destination").permit("country", "state", "city", "zip")
      # Long version:
      #   Changing the packages code to use params.require(:packages => [])
      #   or params.require(:packages) returns the array, which Strong
      #   Parameters no longer recognizes as a params object -- so attempting
      #   to permit the nested objects' attributes won't work.
      # Short version:
      #   Strong Parameters doesn't handle arrays of nested objects very well:
      #   NoMethodError: undefined method `permit' for #<Array:0x007f894dd8c830>

      return result
    end

    def save_shipping_quote_params
      result = {}

      result[:packages] = params.permit("packages" => ["weight", "width", "height", "depth", "product_id"])["packages"]
      result[:origin] = params.require("origin").permit("country", "state", "city", "zip")
      result[:destination] = params.require("destination").permit("country", "state", "city", "zip", "order_id")

      return result
    end

    def shipping_choice_params
      carrier = params.require(:shipping).require(:carrier)
      service_type = params.require(:shipping).require(:service_type)

      return carrier, service_type
    end

    def shipping_selection(quotes, carrier, service_type)
      carrier_key = carrier.downcase.to_sym
      filtered_quotes = quotes[carrier_key]

      selected_shipping_method = filtered_quotes.select do |quote|
        (quote["carrier"] == carrier) && (quote["service_type"] == service_type)
      end

      selected_shipping_method.first
    end
end

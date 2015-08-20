require "#{ Rails.root }/lib/shipping_api.rb"

class FedAxApiController < ApplicationController
  include FedAxApiWrapper

  def quote
    begin
      json_content = ShippingApi.query(shipping_quote_params)
      content = JSON.parse json_content # convert to ruby # FIXME: consider moving this type conversion to the API wrapper

      # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
      if content["status"] == 200
        status = :ok
      else content["status"] == 204
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


  def ship # FIXME: this method should accept & handle for extracting a single shipping method
    begin
      json_content = ShippingApi.query(shipping_quote_params)
      content = JSON.parse json_content # convert to ruby # FIXME: consider moving this type conversion to the API wrapper

      # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
      if content["status"] == 200
        carrier, service_type = shipping_choice_params
        shipping_details = shipping_selection(content["quotes"], carrier, service_type)
        log_entry = ApiResponse.create(shipping_details)
        log_entry.log!(shipping_quote_params)

        content = {}
        content[:receipt] = shipping_details
        content[:message] = "yay log entry saved. successful shipment ftw." # FIXME: better message here
        content[:status] = 201

        status = :created
      else content["status"] == 204
        status = :no_content
      end


    # this is not a hash rocket. it is doing some magic thing where it's assigning
    # the error object to a variable. now we can access the error object's message
    rescue ActionController::ParameterMissing => e
      content = { message: "#{ e.message.capitalize }" }
      status = :bad_request
    rescue ActiveShipping::ResponseError => e
      content = { message: "#{ e.message }" }
      status = :bad_request
    end

    render json: content, status: status
  end

  private
    def shipping_quote_params
      result = {}
      # Long version:
      #   Changing the next line of code to use params.require(:packages => [])
      #   or params.require(:packages) returns the array, which Strong
      #   Parameters no longer recognizes as a params object -- so attempting
      #   to permit the nested objects' attributes won't work.
      # Short version:
      #   Strong Parameters doesn't handle arrays of nested objects very well:
      #   NoMethodError: undefined method `permit' for #<Array:0x007f894dd8c830>
      result[:packages] = params.permit(:packages => [:weight, :width, :height, :depth])[:packages]
      result[:origin] = params.require(:origin).permit(:country, :state, :city, :zip)
      result[:destination] = params.require(:destination).permit(:country, :state, :city, :zip)
      return result
    end

    def shipping_choice_params
      carrier = params.require(:shipping).require(:carrier)
      service_type = params.require(:shipping).require(:service_type)

      return carrier, service_type
    end

    def shipping_selection(quotes, carrier, service_type)
      selected_shipping_method = quotes.select do |quote|
        quote["carrier"] == carrier && quote["service_type"] = service_type
      end

      selected_shipping_method.pop
    end
end

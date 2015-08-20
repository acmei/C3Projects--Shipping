require "#{ Rails.root }/lib/shipping_api.rb"

class FedAxApiController < ApplicationController
  include FedAxApiWrapper

  def quote
    begin
      # code to take in params for making a shipping quote here
      json_content = ShippingApi.query(shipping_params)

      # convert to ruby
      content = JSON.parse json_content

      # should return successful with quote content if APIs respond with quotes
      if content["status"] == 200 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        status = :ok
      # should return successful with no quote content if APIs queried do not ship to or from said location
      else content["status"] == 204 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        status = :no_content
      end


    # this is not a hash rocket. it is doing some magic thing where it's assigning the error object to a variable.
    rescue ActionController::ParameterMissing => e
      # now we can access the error object's message! n_n
      content = { message: "#{ e.message.capitalize }" }
      status = :bad_request
    rescue ActiveShipping::ResponseError => e
      content = { message: "#{ e.message }" }
      status = :bad_request
    end

    render json: content, status: status
  end

  def ship # FIXME: this method should accept & handle for extracting a single shipping method
    begin
      # code to take in params for making a shipping quote here
      json_content = ShippingApi.query(shipping_params)

      # convert to ruby
      content = JSON.parse json_content

      # should return successful with quote content if APIs respond with quotes
      if content["status"] == 200 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        # TODO: code to ship something
        # aka code to save something to the log
        status = :created
      # should return successful with no quote content if APIs queried do not ship to or from said location
      else content["status"] == 204 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        status = :no_content
      end


    # this is not a hash rocket. it is doing some magic thing where it's assigning the error object to a variable.
    rescue ActionController::ParameterMissing => e
      # now we can access the error object's message! n_n
      content = { message: "#{ e.message.capitalize }" }
      status = :bad_request
    rescue ActiveShipping::ResponseError => e
      content = { message: "#{ e.message }" }
      status = :bad_request
    end

    render json: content, status: status
  end

  private
    def shipping_params
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
end

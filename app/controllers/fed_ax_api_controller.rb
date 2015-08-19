require "#{ Rails.root }/lib/shipping_api.rb"

class FedAxApiController < ApplicationController
  include FedAxApiWrapper

  def quote
    begin
      # code to take in params for making a shipping quote here
      json_quotes = ShippingApi.query(shipping_params)

      # convert to ruby
      quotes = JSON.parse json_quotes

      # should return successful with quote content if APIs respond with quotes
      if quotes["status"] == 200 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        render json: quotes, status: :ok

      # should return successful with no quote content if APIs queried do not ship to or from said location
      else quotes["status"] == 204 # OPTIMIZE: is this the best way to handle response status from the API Wrapper?
        render json: quotes, status: :no_content
      end

    rescue ActionController::ParameterMissing
      render json: { message: "error BAD PARAMS YO" }, status: :bad_request # FIXME: I need a better error message
    end
  end

  def ship
    # code to ship something
    # aka code to save something to the log
    # should return successful if the log entry saves correctly
    # should return not successful if there is a problem with processing
    render json: {}, status: :ok
  end

  private
    def shipping_params
      result = {}
      result[:packages] = params.require(:packages)
      result[:origin] = params.require(:origin).permit(:country, :state, :city, :zip)
      result[:destination] = params.require(:destination).permit(:country, :state, :city, :zip)
      return result
    end
end

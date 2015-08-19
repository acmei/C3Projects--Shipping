class FedAxApiController < ApplicationController
  def quote
    # code to take in params for making a shipping quote here
    # should return successful with quote content if APIs respond with quotes
    result = { quotes: [
      {
        "carrier": "bats united",
        "total_cost": "10 pounds of fruit and nuts",
        "service_type": "10-day air service"
      },
      {
        "carrier": "drone pigeons",
        "total_cost": "6 pounds of grains, seeds, and berries",
        "service_type": "7-day ground service"
      }
    ]}
    
    # should return successful with no quote content if APIs queried do not ship to or from said location
    render json: result, status: :ok
  end

  def ship
    # code to ship something
    # aka code to save something to the log
    # should return successful if the log entry saves correctly
    # should return not successful if there is a problem with processing
    render json: {}, status: :ok
  end
end

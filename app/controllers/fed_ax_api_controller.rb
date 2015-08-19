class FedAxApiController < ApplicationController
  def quote
    # code to take in params for making a shipping quote here
    # should return successful with quote content if APIs respond with quotes
    # should return successful with no quote content if APIs queried do not ship to or from said location
  end

  def ship
    # code to ship something
    # aka code to save something to the log
    # should return successful if the log entry saves correctly
    # should return not successful if there is a problem with processing
  end
end

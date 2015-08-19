require 'rails_helper'

RSpec.describe FedAxApiController, type: :controller do
  describe "GET #quote" do
    context "valid inputs" do
      it "responds successfully"
      it "takes in some package, origin, and destination information"
      it "returns a json object"

      context "the returned json object" do
        it "contains a success code ???"
        it "contains an array of quote data"
        it "includes only these specific keys: ????"
        it "includes quote data only for the shippers requested"
      end
    end

    context "invalid inputs" do
      context "address out of area" do
        it "responds successfully maybe? 204 status?"
        it "sends a helpful error message"
        it "does not include quote data"
      end

      context "missing parameters" do
        it "responds with a ??? error code"
        it "sends a helpful error message"
        it "does not include quote data"
      end

      context "invalid parameters" do
        it "responds with a ??? error code"
        it "sends a helpful error message"
        it "does not include quote data"
      end

      context "missing client key ???" do
        it "responds with a ??? error code"
        it "sends a helpful error message"
        it "does not include quote data"
      end
    end
  end

  describe "POST #ship" do
    it "response successfully"
    it "takes in some package, origin, and destination information"
    it "returns a json object"

    context "the returned json object" do
      it "returns a shipped status code maybe?"
      it "contains an array of quote data"
      it "includes only these specific keys: ????"
      it "includes quote data only for the shippers requested"
    end
  end
end

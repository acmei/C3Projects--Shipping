require "rails_helper"
require "#{ Rails.root }/lib/shipping_api.rb"
include FedAxApiWrapper


RSpec.describe FedAxApiWrapper do
  let(:valid_package) { { weight: "1.5", height: "1.5", width: "1.5", depth: "1.5" } }
  let(:another_valid_package) { { weight: "2.5", height: "2.5", width: "2.5", depth: "2.5" } }
  let(:valid_packages) { [valid_package, another_valid_package] }
  let(:valid_origin) { { country: "US", state: "WA", city: "Seattle", zip: "98101" } }
  let(:valid_destination) { { country: "US", state: "IL", city: "Chicago", zip: "60652" } }

  let(:shipping_params) {
    {
      origin: valid_origin,
      destination: valid_destination,
      packages: valid_packages
    }
  }

  describe "class methods" do
    describe "self.query" do
      context "with valid parameters" do
        before :each do
          VCR.use_cassette("ShippingApi_valid") do
            @response = ShippingApi.query(shipping_params)
          end
        end

        it "returns a json object" do
          expect(@response.class).to eq String
          expect(JSON.parse(@response).class).to eq Hash
        end
      end
    end

    describe "self.extract_data_from_response" do
      before :each do
        VCR.use_cassette("ShippingApi_UPS") do
          response = ShippingApi.ups_query(shipping_params)
          @response = ShippingApi.extract_data_from_response(response)
        end
      end

      it "returns an array of shipping cost esimates" do
        expect(@response.class).to be Array
      end

      context "the estimates" do
        it "contain only carrier, total_cost, service_type, & expected_delivery data" do
          response = @response.first
          expected_keys = ["carrier", "total_cost", "service_type", "expected_delivery"]
          optional_key = "expected_delivery"

          expected_keys.each do |expected_key|
            expect(response.keys).to include(expected_key) unless expected_key == optional_key
          end

          expect(response.keys.count).to be <= expected_keys.count
        end
      end
    end
  end
end

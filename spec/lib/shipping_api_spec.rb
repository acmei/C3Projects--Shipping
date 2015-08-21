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
    describe "extracting data from responses" do
      before :each do
        VCR.use_cassette("ShippingApi_extraction") do
          ups_response = ShippingApi.ups_query(shipping_params)
          @ups_response = ShippingApi.extract_data_from_ups_response(ups_response)
          usps_response = ShippingApi.usps_query(shipping_params)
          @usps_response = ShippingApi.extract_data_from_usps_response(usps_response)
        end
      end

      it "returns an array of shipping cost esimates" do
        expect(@ups_response.class).to be Array
        expect(@usps_response.class).to be Array
      end

      context "the estimates" do
        let(:expected_keys) { ["carrier", "total_price", "service_type", "expected_delivery"] }
        let(:optional_key) { "expected_delivery" }

        it "contain only carrier, total_cost, service_type, & expected_delivery info" do
          ups_response = @ups_response.first
          usps_response = @usps_response.first

          expected_keys.each do |expected_key|
            expect(ups_response.keys).to include(expected_key) unless expected_key == optional_key
            expect(usps_response.keys).to include(expected_key) unless expected_key == optional_key
          end

          expect(ups_response.keys.count).to be <= expected_keys.count
          expect(usps_response.keys.count).to be <= expected_keys.count
        end
      end
    end
  end
end

require 'rails_helper'
require "support/shared_controller_examples"

RSpec.describe FedAxApiController, type: :controller do
  # setting up some variables that should permit valid interactions
  let(:valid_package) { { weight: 1.5, height: 1.5, width: 1.5, depth: 1.5 } }
  let(:another_valid_package) { { weight: 2.5, height: 2.5, width: 2.5, depth: 2.5 } }
  let(:valid_packages) { [valid_package, another_valid_package] }
  let(:valid_origin) { { country: "US", state: "WA", city: "Seattle", zip: "98101" } }
  let(:valid_destination) { { country: "US", state: "IL", city: "Chicago", zip: "60652" } }
  let(:shipping_choice_params) { { carrier: "UPS", service_type: "UPS Three-Day Select" } }

  # package these things in json
  let(:json_body) { { origin: valid_origin, destination: valid_destination, packages: valid_packages }.to_json }

  # setting up some variables that should break stuff
  let(:invalid_package) { [{ weight: "apples", height: "bananas", width: "avocados", depth: "pineco" }] }
  let(:invalid_origin) { { country: "US", state: "WA", city: "Houston", zip: "60652" } }
  let(:invalid_destination) { { country: "US", state: "OH", city: "Boise", zip: "20002" } }

  describe "GET #quote" do
    context "valid inputs" do
      before :each do
        VCR.use_cassette("ShippingAPI_valid") do
          get :quote, packages: valid_packages, origin: valid_origin, destination: valid_destination
        end
      end

      it_behaves_like "HTTP 200 success"
      it_behaves_like "HTTP JSON response"

      context "the returned hash object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "contains a successful status code" do
          expect(@response["status"]).to eq 200
        end

        it_behaves_like "shipping quotes"
      end
    end

    context "invalid inputs" do
      context "missing parameters" do
        before :each do
          get :quote
        end

        it_behaves_like "shipping query missing parameters"
      end

      context "invalid parameters" do
        context "origin address" do
          before :each do
            VCR.use_cassette("FedAx_bad_origin") do
              get :quote, packages: valid_packages, origin: invalid_origin, destination: valid_destination
            end
          end

          it_behaves_like "shipping query with bad address"
        end

        context "destination address" do
          before :each do
            VCR.use_cassette("FedAx_bad_destination") do
              get :quote, packages: valid_packages, origin: valid_origin, destination: invalid_destination
            end
          end

          it_behaves_like "shipping query with bad address"
        end
      end

      context "missing client key DO WE WANT bEtsy TO HAVE A CLIENT KEY / ID???" do
        before :each do
          VCR.use_cassette("FedAx_bad_client_id") do
            get :quote, packages: valid_packages, origin: valid_origin, destination: valid_destination
          end
        end

        it_behaves_like "HTTP 400 client error"

        context "the returned json object" do
          before :each do
            @response = JSON.parse response.body
          end

          it "sends a helpful error message" do
            expect(@response["message"]).to include("error")
          end

          it "does not include quotes" do
            expect(@response["quotes"]).to be_nil
          end
        end
      end
    end
  end

  describe "POST #ship" do
    context "valid inputs" do
      before :each do
        VCR.use_cassette("ShippingAPI_valid") do
          post :ship, packages: valid_packages, origin: valid_origin, destination: valid_destination, shipping: shipping_choice_params
        end
      end

      it_behaves_like "HTTP 201 success"
      it_behaves_like "HTTP JSON response"

      context "adding the API response data to the log" do
        it "creates new packages in the DB" do
          expect(Package.last.height).to eq another_valid_package[:height]
        end

        it "creates a new origin in the DB" do
          expect(Origin.last.zip).to eq valid_origin[:zip]
        end

        it "creates a new desination in the DB" do
          expect(Destination.last.zip).to eq valid_destination[:zip]
        end

        it "creates a new log entry in the DB" do
          expect(ApiResponse.last.total_price).to eq 4210 # $42.10 -- hmmm, not bad for 3-day shipping
        end
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "contains a successful status code" do
          expect(@response["status"]).to eq 201
        end

        it "contains a receipt hash" do
          expect(@response["receipt"].class).to eq Hash
        end

        context "the receipt object" do
          before :each do
            @receipt = @response["receipt"]
          end

          it "contains the total price of shipping" do
            expect(@receipt["total_price"]).to_not be_nil
          end

          it "contains a description of the service type" do
            expect(@receipt["service_type"]).to_not be_nil
          end

          it "has a carrier" do
            expect(@receipt["carrier"]).to_not be_nil
          end
        end
      end
    end

    context "invalid inputs" do
      context "missing parameters" do
        before :each do
          post :ship
        end

        it_behaves_like "shipping query missing parameters"
      end

      context "invalid parameters" do
        context "origin address" do
          before :each do
            VCR.use_cassette("FedAx_bad_origin") do
              post :ship, packages: valid_packages, origin: invalid_origin, destination: valid_destination, shipping: shipping_choice_params
            end
          end

          it_behaves_like "shipping query with bad address"
        end

        context "destination address" do
          before :each do
            VCR.use_cassette("FedAx_bad_destination") do
              post :ship, packages: valid_packages, origin: valid_origin, destination: invalid_destination, shipping: shipping_choice_params
            end
          end

          it_behaves_like "shipping query with bad address"
        end
      end

      context "missing client key DO WE WANT bEtsy TO HAVE A CLIENT KEY / ID???" do
        before :each do
          VCR.use_cassette("FedAx_bad_client_id") do
            post :ship, packages: valid_packages, origin: valid_origin, destination: valid_destination, shipping: shipping_choice_params
          end
        end

        it_behaves_like "HTTP 400 client error"

        context "the returned json object" do
          before :each do
            @response = JSON.parse response.body
          end

          it "sends a helpful error message" do
            expect(@response["message"]).to include("error")
          end

          it "does not include receipt" do
            expect(@response["receipt"]).to be_nil
          end
        end
      end
    end
  end
end

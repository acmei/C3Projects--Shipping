require 'rails_helper'

RSpec.describe FedAxApiController, type: :controller do
  let(:valid_package) { { weight: "1.5", height: "1.5", width: "1.5", depth: "1.5" } }
  let(:another_valid_package) { { weight: "2.5", height: "2.5", width: "2.5", depth: "2.5" } }
  let(:valid_packages) { [valid_package, another_valid_package] }
  let(:valid_origin) { { country: "US", state: "WA", city: "Seattle", zip: "98101" } }
  let(:valid_destination) { { country: "US", state: "IL", city: "Chicago", zip: "60652" } }
  let(:invalid_package) { [{ weight: "apples", height: "bananas", width: "avocados", depth: "pineco" }] }
  let(:invalid_origin) { { country: "US", state: "WA", city: "Houston", zip: "60652" } }
  let(:invalid_destination) { { country: "US", state: "OH", city: "Boise", zip: "20002" } }
  let(:origin_out_of_area) { { country: "AQ", state: "AQ", city: "Santa's Summer House", zip: "11111" } }
  let(:destination_out_of_area) { { country: "AQ", state: "AQ", city: "Santa's Spring and Fall House", zip: "11111" } }

  describe "GET #quote" do
    context "valid inputs" do
      before :each do
        VCR.use_cassette("ShippingAPI_valid") do
          get :quote, packages: valid_packages, origin: valid_origin, destination: valid_destination
        end
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "returns a json object" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "contains a successful status code" do
          expect(@response["status"]).to eq 200
        end

        it "contains an array of quotes" do
          expect(@response["quotes"].class).to eq Array
          # TODO: more?
        end

        context "each quote in the quotes array" do
          before :each do
            @quotes = @response["quotes"]
          end

          it "contains the total cost of shipping" do
            @quotes.each do |quote|
              expect(quote["total_cost"]).to_not be_nil
            end
          end

          it "contains a description of the service type" do
            @quotes.each do |quote|
              expect(quote["service_type"]).to_not be_nil
            end
          end

          it "has a carrier" do
            @quotes.each do |quote|
              expect(quote["carrier"]).to_not be_nil
            end
          end
        end
      end
    end

    context "invalid inputs" do
      context "missing parameters" do
        before :each do
          get :quote
        end

        it "responds with a bad request status" do
          expect(response).to have_http_status 400
        end

        context "the returned json object" do
          before :each do
            @response = JSON.parse response.body
          end

          it "sends a helpful error message" do
            expect(@response["message"]).to include("Param is missing")
          end

          it "does not include quotes" do
            expect(@response["quotes"]).to be_nil
          end
        end
      end

      context "invalid parameters" do
        context "origin address" do
          before :each do
            VCR.use_cassette("FedAx_bad_origin") do
              get :quote, packages: valid_packages, origin: invalid_origin, destination: valid_destination
            end
          end

          it "responds with a bad request status" do
            expect(response).to have_http_status 400
          end

          context "the returned json object" do
            before :each do
              @response = JSON.parse response.body
            end

            it "sends a helpful error message" do
              expect(@response["message"]).to include("Failure:")
            end

            it "does not include quotes" do
              expect(@response["quotes"]).to be_nil
            end
          end
        end

        context "destination address" do
          before :each do
            VCR.use_cassette("FedAx_bad_destination") do
              get :quote, packages: valid_packages, origin: valid_origin, destination: invalid_destination
            end
          end

          it "responds with a bad request status" do
            expect(response).to have_http_status 400
          end

          context "the returned json object" do
            before :each do
              @response = JSON.parse response.body
            end

            it "sends a helpful error message" do
              expect(@response["message"]).to include("Failure:")
            end

            it "does not include quotes" do
              expect(@response["quotes"]).to be_nil
            end
          end
        end
      end

      context "missing client key DO WE WANT bEtsy TO HAVE A CLIENT KEY / ID???" do
        before :each do
          get :quote, packages: valid_packages, origin: valid_origin, destination: valid_destination
        end

        it "responds with a bad request status" do
          expect(response).to have_http_status 400
        end

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

end

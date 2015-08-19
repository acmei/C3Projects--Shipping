require 'rails_helper'

RSpec.describe FedAxApiController, type: :controller do
  let(:valid_package) { size: "1.5", height: "1.5", width: "1.5", depth: "1.5" }
  let(:valid_origin) { county: "US", state: "WA", city: "Houston", zip: "60652" }
  let(:valid_destination) { county: "US", state: "OH", city: "Boise", zip: "20002" }
  let(:origin_out_of_area) { false }
  let(:destination_out_of_area) { false }

  describe "GET #quote" do
    context "valid inputs" do
      before :each do
        get :quote, package: valid_package, origin: valid_origin, destination: valid_destination
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

        it "contains a success code ???"

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
      context "address out of area" do
        before :each do
          get :quote, package: valid_package, origin: origin_out_of_area, destination: destination_out_of_area
        end

        it "responds successfully maybe? 204 status?" do
          expect(response).to have_http_status 204
        end

        it "returns a json object" do
          expect(response.header['Content-Type']).to include 'application/json'
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
            expect(@response["message"]).to include("error")
          end

          it "does not include quotes" do
            expect(@response["quotes"]).to be_nil
          end
        end
      end

      context "invalid parameters" do
        before :each do
          get :quote, packages: invalid_packages, origin: invalid_origin, destination: invalid_destination
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

      context "missing client key ???" do
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

  describe "POST #ship" do
    context "valid input" do
      before :each do
        post :ship, package: valid_package, origin: valid_origin, destination: valid_destination
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "takes in some package, origin, and destination information"
        # FIXME: test

      it "returns a json object" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          @response = JSON.parse response.body
        end

        it "returns a shipped status code maybe?"

        it "contains an array of quotes" do
          expect(@response["quote"].class).to eq Array
          # TODO: more
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

          it "contains tracking information where available" do
            @quotes.each do |quote|
              # FIXME: this is made up. not sure yet which carriers offer tracking info
              expect(quote["tracking_info"]).to_not be_nil if quote["carrier"] == "UPS"
            end
          end
        end
      end
    end

    context "invalid inputs" do
      context "address out of area" do
        before :each do
          get :quote, package: valid_package, origin: origin_out_of_area, destination: destination_out_of_area
        end

        it "responds successfully maybe? 204 status?" do
          expect(response).to have_http_status 204
        end

        it "returns a json object" do
          expect(response.header['Content-Type']).to include 'application/json'
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

      context "missing parameters" do
        it "responds with a ??? error code"
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

      context "invalid parameters" do
        it "responds with a ??? error code"
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

      context "missing client key ???" do
        it "responds with a ??? error code"
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

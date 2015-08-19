require 'rails_helper'

RSpec.describe FedAxApiController, type: :controller do
  let(:valid_package) { true }
  let(:valid_origin) { true }
  let(:valid_destination) { true }
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

        it "contains an array of quote data" do
          expect(@response["quote"]).to_not be_nil
          # TODO: more
        end

        it "includes only these specific keys: ????"
        it "includes quote data only for the shippers requested"
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
          end
        end
      end
    end
  end

  describe "POST #ship" do
    context "valid input" do
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

        it "contains an array of quote data" do
          expect(@response["quote"]).to_not be_nil
          # TODO: more
        end

        it "includes only these specific keys: ????"
        it "includes quote data only for the shippers requested"
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
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

          it "does not include quote data" do
            expect(@response["quote"]).to be_nil
          end
        end
      end
    end
  end
end

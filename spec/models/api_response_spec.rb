require 'rails_helper'

RSpec.describe ApiResponse, type: :model do
	let(:api_response) { create :api_response }

  describe "model validations" do
	  required_fields = [:carrier, :total_price, :service_type]

	  required_fields.each do |field|
	    it "requires a #{ field }" do
	      api_response_without_attribute = build :api_response, field => nil
	      expect(api_response.errors.keys).not_to include(field)
	      expect(api_response_without_attribute).to be_invalid
	    end
	  end

    context "carrier" do
      it "must be a valid carrier" do
        invalid_carriers = ["Exploding Pigeons", "Bats United", "Drone Delivery of Super-packages"]
        valid_carriers = ["UPS"]

        invalid_carriers.each do |carrier|
          invalid_api_response = build :api_response, carrier: carrier
          expect(invalid_api_response).to be_invalid
        end

        valid_carriers.each do |carrier|
          valid_api_response = build :api_response, carrier: carrier
          expect(valid_api_response).to be_valid
          valid_api_response.save!
          expect(valid_api_response.errors.keys).to_not include(:carrier)
        end
      end
    end
	end

  describe "model associations" do
  	let(:package1) { create :package, api_response_id: api_response.id }
    let(:package2) { create :package, api_response_id: api_response.id }
    let(:origin) { create :origin, api_response_id: api_response.id }
    let(:destination) { create :destination, api_response_id: api_response.id }

    it "has one destination" do
      destination
      expect(api_response.destination).to eq(destination)
    end

    it "has one origin" do
      origin
      expect(api_response.origin).to eq(origin)
    end

    it "has one to many packages" do
      package1; package2
      expect(api_response.packages).to include(package1)
      expect(api_response.packages).to include(package2)
    end
  end
end

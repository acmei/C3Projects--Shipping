require 'rails_helper'

RSpec.describe Package, type: :model do
  describe "model validations" do
  	let(:package) { create :package }

	  required_fields = [:weight, :height, :width, :api_response_id]

	  required_fields.each do |field|
	    it "requires a #{ field }" do
	      package_without_attribute = build :package, field => nil
	      expect(package.errors.keys).not_to include(field)
	      expect(package_without_attribute).to be_invalid
	    end
	  end
	end

  describe "model associations" do
  	let(:package) { create :package }
    let(:api_response) { create :api_response }

    it "belongs to an api_response" do
      api_response
      expect(package.api_response).to eq(api_response)
    end
  end
end

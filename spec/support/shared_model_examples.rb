RSpec.shared_examples "address" do
  class_string = described_class.to_s.downcase
  class_symbol = class_string.to_sym

  describe "model validations" do
    let(:address) { create class_symbol }
    let(:countryless_address) { create ("countryless_" + class_string).to_sym }

    required_fields = [:state, :city, :zip, :api_response_id]

    required_fields.each do |field|
      it "requires a #{ field }" do
        address_without_attribute = build class_symbol, field => nil
        expect(address.errors.keys).not_to include(field)
        expect(address_without_attribute).to be_invalid
      end
    end

    it "has a default value of 'US' for country" do
      expect(address.errors.keys).not_to include(:country)
      expect(countryless_address.country).to eq('US')
    end

    valid_zips = ["12345", "98019", "02930"]

    valid_zips.each do |valid_zip|
      it "requires a valid 5-digit zip: #{valid_zip}" do
        address.zip = valid_zip
        expect(address).to be_valid
        expect(address.errors.keys).not_to include(:zip)
      end
    end

    invalid_zips = ["9382", "31", "zipco"]

    invalid_zips.each do |invalid_zip|
      it "does not validate an non-5-digit zip: #{invalid_zip}" do
        address.zip = invalid_zip
        expect(address).to be_invalid
        expect(address.errors.keys).to include(:zip)
      end
    end
  end

  describe "model associations" do
    let(:api_response) { create :api_response }
    let(:address) { create class_symbol }

    it "belongs to an api_response" do
      api_response
      expect(address.api_response).to eq(api_response)
    end
  end
end

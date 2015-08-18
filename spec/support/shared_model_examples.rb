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

module FedAxApiWrapper
  class ShippingApi
    def self.query(delivery_info)
      quotes = []
      full_response = self.ups_query(delivery_info)
      quotes.push self.extract_data_from_response(full_response)

      if quotes.empty?
        response = { message: "not great! no content!", status: 204}.to_json
      else
        quotes.flatten!
        response = { quotes: quotes, message: "great!", status: 200 }.to_json
      end
    end

    def self.extract_data_from_response(response)
      combined_results = []
      rates = response.rates

      rates.each do |rate|
        result = {}
        result["carrier"] = rate.carrier # "UPS"
        result["total_cost"] = rate.total_price / 100.0 # price in cents
        result["service_type"] = rate.service_name # "UPS Ground"
        result["expected_delivery"] = rate.delivery_date # nil or timedate

        combined_results.push(result)
      end

      combined_results.flatten!

      return combined_results
    end

    # unpacking & standardizing delivery specifications
    def self.unpack_delivery_specs(delivery_specifications)
      origin = ActiveShipping::Location.new(delivery_specifications[:origin])
      destination = ActiveShipping::Location.new(delivery_specifications[:destination])
      packages = delivery_specifications[:packages].map{ |package|
        ActiveShipping::Package.new(
          package["size"].to_i,
          [
            package["height"].to_i,
            package["width"].to_i,
            package["depth"].to_i
          ],
          units: :imperial
        )
      }
      return origin, destination, packages
    end

    def self.ups_query(delivery_info)
      origin, destination, packages = self.unpack_delivery_specs(delivery_info)
      response = self.ups_carrier.find_rates(origin, destination, packages)
    end

    def self.ups_carrier
      ActiveShipping::UPS.new(self.ups_credentials)
    end

    def self.ups_credentials
      { login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"] }
    end
  end
end

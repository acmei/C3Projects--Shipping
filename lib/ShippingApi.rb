module FedAxApiWrapper
  class ShippingApi
    def query(origin, destination, packages)
      result = []
      result.push ups_query(origin, destination, packages)
      result.push usps_query(origin, destination, packages)
      return result#.flatten
    end

    private
      def extract_data_from_response(response)
        combined_results = []
        rates = reponse.rates

        rates.each do |rate|
          result = {}
          # "carrier": "bats united",
          # "total_cost": "10 pounds of fruit and nuts",
          # "service_type": "10-day air service"

          result["carrier"] = rate.carrier # "UPS"
          result["total_cost"] = rate.total_price / 100.0 # price in cents
          result["service_type"] = rate.service_name # "UPS Ground"
          result["expected_delivery"] = rate.delivery_date # nil or timedate

          combined_results.push(result)
        end

        return combined_results.to_json
      end

      def ups_query(origin, destination, packages)
        response = ups_carrier.find_rates(origin, destination, packages)
        extract_data_from_response(response)
      end

      def ups_carrier
        ActiveShipping::UPS.new(ups_credentials)
      end

      def ups_credentials
        { login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"] }
      end
  end
end

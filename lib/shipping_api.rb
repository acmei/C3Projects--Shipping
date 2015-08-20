module FedAxApiWrapper
  class ShippingApi
    def self.query(delivery_info)
      # delivery_info is the packages, origin, and destination information passed
      # into the API from the user -- in this case, bEtsy.
      ups_response = self.ups_query(delivery_info)
      ups_quotes = self.extract_data_from_response(ups_response)

      usps_response = self.ups_query(delivery_info)
      usps_quotes = self.extract_data_from_response(usps_response)

      quotes = {}
      quotes[:ups] = ups_quotes
      quotes[:usps] = usps_quotes

      if quotes[:ups].empty? || quotes[:usps].empty?
        response = { status: 204 } # FIXME: message here?
      else
        response = { quotes: quotes, status: 200 }
      end
    end

    def self.extract_data_from_response(response)
      combined_results = []

      # this is made available to us by the ActiveShipping gem.
      rates = response.rates

      rates.each do |rate|
        result = {}

        # these methods are also made available to us by the ActiveShipping gem.
        result["carrier"] = rate.carrier # "UPS"
        result["total_price"] = rate.total_price # price in cents
        result["service_type"] = rate.service_name # "UPS Ground"
        result["expected_delivery"] = rate.delivery_date # nil or timedate
        # result["tracking_number"] = ???? if ????

        combined_results.push(result)
      end

      return combined_results
    end

    # standardizing delivery specifications by converting them to ActiveShipping objects
    def self.standardize_delivery_specs(delivery_specifications)
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

    # TODO: consider adding more handling for data types to the strong params in the controller.
    def self.ups_query(delivery_info) # FIXME: add doc comment to explain what's going on here.
      origin, destination, packages = self.standardize_delivery_specs(delivery_info)
      response = self.ups_carrier.find_rates(origin, destination, packages)
    end

    def self.ups_carrier
      ups_credentials = {
        login: ENV["UPS_LOGIN"],
        password: ENV["UPS_PASSWORD"],
        key: ENV["UPS_KEY"]
      }
      return ActiveShipping::UPS.new(ups_credentials)
    end

    def self.usps_query(delivery_info) # FIXME: add doc comment to explain what's going on here.
      origin, destination, packages = self.standardize_delivery_specs(delivery_info)
      response = self.usps_carrier.find_rates(origin, destination, packages)
    end

    def self.usps_carrier
      usps_credentials = {
        login: ENV["USPS_LOGIN"]
      }
      return ActiveShipping::USPS.new(usps_credentials)
    end
  end
end

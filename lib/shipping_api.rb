module FedAxApiWrapper
  class ShippingApi
    def self.query(delivery_info)
      # delivery info is the packages, origin, and destination information passed
      # into the API from the user -- in this case, bEtsy.
      full_response = self.ups_query(delivery_info)
      quotes = self.extract_data_from_response(full_response)

      if quotes.empty? # FIXME: better messages in json responses
        response = { message: "not great! no content!", status: 204 } # FIXME: better message here
      else
        response = { quotes: quotes, message: "great!", status: 200 } # FIXME: better message here
      end
    end

    def self.extract_data_from_response(response)
      combined_results = []
      rates = response.rates # this is made available to us by the ActiveShipping gem

      rates.each do |rate|
        result = {}

        result["carrier"] = rate.carrier # "UPS"
        result["total_price"] = rate.total_price # price in cents
        result["service_type"] = rate.service_name # "UPS Ground"
        result["expected_delivery"] = rate.delivery_date # nil or timedate
        # result["tracking_number"] = ???? if ????

        combined_results.push(result)
      end

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

    # TODO: consider adding more handling for data types to the strong params in the controller.
    def self.ups_query(delivery_info) # FIXME: add doc comment to explain what's going on here.
      origin, destination, packages = self.unpack_delivery_specs(delivery_info)
      response = self.ups_carrier.find_rates(origin, destination, packages)
    end

    def self.ups_carrier
      ups_credentials = {
        login: ENV["UPS_LOGIN"],
        password: ENV["UPS_PASSWORD"],
        key: ENV["UPS_KEY"]
      }
      ActiveShipping::UPS.new(ups_credentials)
    end
  end
end

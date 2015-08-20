> ## credential setup

`ups_credentials = {
  login: ENV["UPS_LOGIN"],
  password: ENV["UPS_PASSWORD"],
  key: ENV["UPS_KEY"]
}`

`carrier = ActiveShipping::UPS.new(ups_credentials)`

> ## package, origin, & destination setup

`package1_options = { cylinder: true }`

`package1 = ActiveShipping::Package.new(
  100,
  [93,10],
  package1_options
)` this is a cylinder package that weighs 100 grams and which is 93cm x 10cm

`package2_options = { units: :imperial }` this sets the units to imperial (no more metric!)

`package2 = ActiveShipping::Package.new(
  7.5 * 16,
  [15, 10, 4.5],
  package2_options
)` this is a rectangular package that weights 7.5 pounds and which is 15" x 10" x 4.5"

`packages = [package1, package2]`

`combo_killer = { units: :imperial, cylinder: true }`

`package3 = ActiveShipping::Package.new(
  100,
  [93,10],
  combo_killer
)` this is a cylinder package that weights 100 ounces and which is 93" x 10"

`origin = ActiveShipping::Location.new(
  country: "US",
  state: "IL",
  city: "Chicago",
  zip: "60652"
)`

`destination = ActiveShipping::Location.new(
  country: "US",
  state: "CA",
  city: "Beverly Hills",
  zip: "90210"
)`

> ## finding rates

`response = carrier.find_rates(origin, destination, packages)`

services codes  
- 03 = UPS Ground
- 12 = UPS Three-Day Select
- 02 = UPS Second Day Air
- 14 = UPS Next Day Air Early AM
- 13 = UPS Next Day Air Saver
- 01 = UPS Next Day Air

service name - `response.rates.first.service_name`  

service code - `response.rates.first.service_code`

cost - `response.rates.first.total_price` price in cents

delivery_date - `response.rates.first.delivery_date` estimated delivery date


> ## original response from API

- {"Response"=>
  - {"ResponseStatusCode"=>"1", "ResponseStatusDescription"=>"Success"},
  - "RatedShipment"=>
    - [{"Service"=>{"Code"=>"03"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"29.96"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"29.96"},
    - "GuaranteedDaysToDelivery"=>nil,
    - "ScheduledDeliveryTime"=>nil,
    - "RatedPackage"=>
      - [{"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"14.29"},
      - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
      - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"14.29"},
      - "Weight"=>"0.3",
      - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}},
    - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"15.67"},
      - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
      - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"15.67"},
      - "Weight"=>"7.5",
      - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}]},
  - {"Service"=>{"Code"=>"12"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"69.40"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"69.40"},
    - "GuaranteedDaysToDelivery"=>"3",
    - "ScheduledDeliveryTime"=>nil,
    - "RatedPackage"=>
      - [
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"28.44"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"28.44"},
        - "Weight"=>"0.3",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}}
      - ,
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"40.96"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"40.96"},
        - "Weight"=>"7.5",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}
      - ]},
  - {"Service"=>{"Code"=>"02"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"97.94"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"97.94"},
    - "GuaranteedDaysToDelivery"=>"2",
    - "ScheduledDeliveryTime"=>nil,
    - "RatedPackage"=>
      - [
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"39.70"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"39.70"},
        - "Weight"=>"0.3",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}}
      - ,
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"58.24"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"58.24"},
        - "Weight"=>"7.5",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}
      - ]},
  - {"Service"=>{"Code"=>"13"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"175.72"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"175.72"},
    - "GuaranteedDaysToDelivery"=>"1",
    - "ScheduledDeliveryTime"=>nil,
    - "RatedPackage"=>
      - [
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"76.42"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"76.42"},
        - "Weight"=>"0.3",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}}
      - ,
        - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"99.30"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"99.30"},
        - "Weight"=>"7.5",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}
      - ]},
  - {"Service"=>{"Code"=>"14"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"252.61"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"252.61"},
    - "GuaranteedDaysToDelivery"=>"1",
    - "ScheduledDeliveryTime"=>"8:30 A.M.",
    - "RatedPackage"=>
      - [{"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"115.02"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"115.02"},
        - "Weight"=>"0.3",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}},
      - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"137.59"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"137.59"},
        - "Weight"=>"7.5",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}]},
  - {"Service"=>{"Code"=>"01"},
    - "RatedShipmentWarning"=>"Your invoice may vary from the displayed reference rates",
    - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"12.0"},
    - "TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"189.75"},
    - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
    - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"189.75"},
    - "GuaranteedDaysToDelivery"=>"1",
    - "ScheduledDeliveryTime"=>"10:30 A.M.",
    - "RatedPackage"=>
      - [{"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"83.59"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"83.59"},
        - "Weight"=>"0.3",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"4.0"}},
      - {"TransportationCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"106.16"},
        - "ServiceOptionsCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"0.00"},
        - "TotalCharges"=>{"CurrencyCode"=>"USD", "MonetaryValue"=>"106.16"},
        - "Weight"=>"7.5",
        - "BillingWeight"=>{"UnitOfMeasurement"=>{"Code"=>"LBS"}, "Weight"=>"8.0"}}]}
  - ]},
  - @rates= [  
    #<ActiveShipping::RateEstimate:0x007fcb6eaa6400
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=nil,
    - @delivery_range=[],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates= [
      - {:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="03",
    - @service_name="UPS Ground",
    - @shipping_date=nil,
    - @total_price=2996>,
  - #<ActiveShipping::RateEstimate:0x007fcb6ea6cca0
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=Fri, 21 Aug 2015 00:00:00 +0000,
    - @delivery_range=[Fri, 21 Aug 2015 00:00:00 +0000],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates=
      - [{:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="12",
    - @service_name="UPS Three-Day Select",
    - @shipping_date=nil,
    - @total_price=6940>,
  - #<ActiveShipping::RateEstimate:0x007fcb6ea5f988
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=Thu, 20 Aug 2015 00:00:00 +0000,
    - @delivery_range=[Thu, 20 Aug 2015 00:00:00 +0000],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates=
      - [{:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="02",
    - @service_name="UPS Second Day Air",
    - @shipping_date=nil,
    - @total_price=9794>,
  - #<ActiveShipping::RateEstimate:0x007fcb6ea55050
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=Wed, 19 Aug 2015 00:00:00 +0000,
    - @delivery_range=[Wed, 19 Aug 2015 00:00:00 +0000],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates=
      - [{:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="13",
    - @service_name="UPS Next Day Air Saver",
    - @shipping_date=nil,
    - @total_price=17572>,
  - #<ActiveShipping::RateEstimate:0x007fcb6ea479f0
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=Wed, 19 Aug 2015 00:00:00 +0000,
    - @delivery_range=[Wed, 19 Aug 2015 00:00:00 +0000],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates=
      - [{:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="14",
    - @service_name="UPS Next Day Air Early A.M.",
    - @shipping_date=nil,
    - @total_price=25261>,
  - #<ActiveShipping::RateEstimate:0x007fcb6ea3e6c0
    - @carrier="UPS",
    - @currency="USD",
    - @delivery_date=Wed, 19 Aug 2015 00:00:00 +0000,
    - @delivery_range=[Wed, 19 Aug 2015 00:00:00 +0000],
    - @destination=Beverly Hills, CA, 90210 United States,
    - @estimate_reference=nil,
    - @expires_at=nil,
    - @insurance_price=0,
    - @negotiated_rate=0,
    - @origin=Chicago, IL, 60652 United States,
    - @package_rates=
      - [{:package=> #<ActiveShipping::Package:0x007fcb708e8788
        - @currency=nil,
        - @cylinder=true,
        - @dimensions=[#<Quantified::Length: 10 centimetres>, #<Quantified::Length: 10 centimetres>, #<Quantified::Length: 93 centimetres>],
        - @dimensions_unit_system=:metric,
        - @gift=false,
        - @inches=[3.937007874015748, 3.937007874015748, 36.61417322834646],
        - @options={:cylinder=>true},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 100 grams>,
        - @weight_unit_system=:metric>},
      - {:package=> #<ActiveShipping::Package:0x007fcb708212f0
        - @currency=nil,
        - @cylinder=false,
        - @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
        - @dimensions_unit_system=:imperial,
        - @gift=false,
        - @inches=[4.5, 10, 15],
        - @options={:units=>:imperial},
        - @oversized=false,
        - @unpackaged=false,
        - @value=nil,
        - @weight=#<Quantified::Mass: 120.0 ounces>,
        - @weight_unit_system=:imperial>}],
    - @pickup_time=nil,
    - @service_code="01",
    - @service_name="UPS Next Day Air",
    - @shipping_date=nil,
    - @total_price=18975>],
.

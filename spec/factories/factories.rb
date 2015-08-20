FactoryGirl.define do
  factory :api_response do
    carrier "UPS"
    tracking_number "asdf967asdg547shdfghd7s53j6s5j3sf67gj"
    expected_delivery Date.parse("June 6, 2092") # oh cool only like 75 years! what a deal.
    service_type "UPS 100 Year Guarantee"
    total_price 10_000 # mmmmm, $100 for 75 years of UPS-warehouse package storage. not bad!
  end

  factory :destination do
    country "CA"
    state "BC"
    city "Vancouver"
    zip "60652"
    api_response_id 1
  end

  factory :countryless_destination, class: Destination do
    state "BC"
    city "Vancouver"
    zip "60652"
    api_response_id 1
  end

  factory :origin do
    country "CA"
    state "BC"
    city "Vancouver"
    zip "60652"
    api_response_id 1
  end

  factory :countryless_origin, class: Origin do
    state "BC"
    city "Vancouver"
    zip "60652"
    api_response_id 1
  end

  factory :package do
    weight 100
    height 5.5
    width 200.25
    depth 15.4
    api_response_id 1
  end
end

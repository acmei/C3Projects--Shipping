FactoryGirl.define do
  factory :api_response do
    # TODO: put response stuff here
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
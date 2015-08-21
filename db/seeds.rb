@api_response = ApiResponse.create(
  carrier: "UPS",
  tracking_number: "asdf967asdg547shdfghd7s53j6s5j3sf67gj",
  expected_delivery: Date.parse("June 6, 2092"), # oh cool only like 75 years! what a deal.
  service_type: "UPS 100 Year Guarantee",
  total_price: 10_000 # mmmmm, $100 for 75 years of UPS-warehouse package storage. not bad!
)

Destination.create(
  country: "CA",
  state: "BC",
  city: "Vancouver",
  zip: "60652",
  api_response: @api_response
)

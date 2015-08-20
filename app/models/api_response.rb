class ApiResponse < ActiveRecord::Base
  # Associations ---------------------------------------------------------------
  has_one :destination
  has_one :origin
  has_many :packages

  # Validations ----------------------------------------------------------------
  CARRIER_REGEX = /\A(UPS)\z/ # FIXME: currently, we only support UPS queries
  validates :carrier, :total_price, :service_type, presence: true
  validates_format_of :carrier, with: CARRIER_REGEX

  # Instance Methods -----------------------------------------------------------
  def log!(shipping_details) # OPTIMIZE: DRY this up with accept_nested_attributes_for
    origin = shipping_details[:origin]
    destination = shipping_details[:destination]
    packages = shipping_details[:packages]

    origin[:api_response_id] = self.id
    Origin.create(origin)

    destination[:api_response_id] = self.id
    Destination.create(destination)

    packages.each do |package|
      package[:api_response_id] = self.id
      Package.create(package)
    end
  end
end

class ApiResponse < ActiveRecord::Base
  # Associations ---------------------------------------------------------------
  has_one :destination
  has_one :origin
  has_many :packages

  # Validations ----------------------------------------------------------------
  CARRIER_REGEX = /\A(UPS)\z/ # currently, we only support UPS queries
  validates :carrier, :total_price, :service_type, presence: true
  validates_format_of :carrier, with: CARRIER_REGEX
end

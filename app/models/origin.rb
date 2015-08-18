class Origin < ActiveRecord::Base
  # Associations ---------------------------------------------------------------
  belongs_to :api_response

  # Validations ----------------------------------------------------------------
  FIVE_DIGIT_STRING_REGEX = /\A\d{5}\z/
  validates :country, :state, :city, :zip, :api_response_id, presence: true
  validates_format_of :zip, with: FIVE_DIGIT_STRING_REGEX
end

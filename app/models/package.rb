class Package < ActiveRecord::Base
	# Associations ---------------------------------------------------------------
  belongs_to :api_response

  # Validations ----------------------------------------------------------------
  validates :weight, :height, :width, :api_response_id, presence: true
  validates :weight, :height, :width, numericality: true
end

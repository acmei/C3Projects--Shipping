require 'rails_helper'
require "support/shared_model_examples"

RSpec.describe Destination, type: :model do
  it_behaves_like "address"
end

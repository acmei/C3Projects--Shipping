class AddColumnsToApiResponseTable < ActiveRecord::Migration
  def change
    add_column :api_responses, :carrier, :string
    add_column :api_responses, :total_price, :integer
    add_column :api_responses, :service_type, :string
    add_column :api_responses, :expected_delivery, :datetime
    add_column :api_responses, :tracking_number, :string

    change_column_null :api_responses, :carrier, false
    change_column_null :api_responses, :total_price, false
    change_column_null :api_responses, :service_type, false
  end
end

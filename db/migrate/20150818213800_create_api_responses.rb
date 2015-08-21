class CreateApiResponses < ActiveRecord::Migration
  def change
    create_table :api_responses do |t| # this is a foreign_key to a betsy object
      t.integer :order_id, foreign_key: false
      t.timestamps null: false
    end
  end
end

class CreateApiResponses < ActiveRecord::Migration
  def change
    create_table :api_responses do |t|

      t.timestamps null: false
    end
  end
end

class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string :country, default: "US", null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.references :api_response, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end

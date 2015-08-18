class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.float :weight, null: false
      t.float :height, null: false
      t.float :width, null: false
      t.float :depth, null: false
      t.references :api_response, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

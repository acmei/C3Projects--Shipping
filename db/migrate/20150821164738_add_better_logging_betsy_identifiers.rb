class AddBetterLoggingBetsyIdentifiers < ActiveRecord::Migration
  def change
    add_column :packages, :product_id, :integer, foreign_key: false
    add_column :destinations, :order_id, :integer, foreign_key: false
  end
end

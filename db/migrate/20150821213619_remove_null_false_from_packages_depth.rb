class RemoveNullFalseFromPackagesDepth < ActiveRecord::Migration
  def change
    change_column_null :packages, :depth, true
  end
end

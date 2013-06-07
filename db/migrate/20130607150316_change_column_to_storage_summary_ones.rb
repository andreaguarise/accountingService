class ChangeColumnToStorageSummaryOnes < ActiveRecord::Migration
  def up
    change_column :storage_summary_ones,:resourceCapacityUsed, :integer, :limit => 8
    change_column :storage_summary_ones,:resourceCapacityAllocated, :integer, :limit => 8
    change_column :storage_summary_ones,:logicalCapacityUsed, :integer, :limit => 8
  end

  def down
  end
end

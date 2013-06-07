class ChangeColumnToEmiStorageRecordsBis < ActiveRecord::Migration
  def up
    change_column :emi_storage_records,:resourceCapacityUsed, :integer, :limit => 20
    change_column :emi_storage_records,:resourceCapacityAllocated, :integer, :limit => 20
    change_column :emi_storage_records,:logicalCapacityUsed, :integer, :limit => 20
    change_column :emi_storage_records,:fileCount, :integer, :limit => 20
  end

  def down
  end
end

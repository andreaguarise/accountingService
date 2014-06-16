class AddIndexToEmiStorageRecords < ActiveRecord::Migration
  def change
    add_index :emi_storage_records, :publisher_id
  end
end

class AddPublisherIdToEmiStorageRecords < ActiveRecord::Migration
  def change
    add_column :emi_storage_records, :publisher_id, :integer
  end
end

class AddPublisherIdToCloudRecords < ActiveRecord::Migration
  def change
    add_column :cloud_records, :publisher_id, :integer
  end
end

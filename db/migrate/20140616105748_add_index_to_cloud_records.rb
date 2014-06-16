class AddIndexToCloudRecords < ActiveRecord::Migration
  #add indexes used to speed up the queries within the populateGridCpuRecords.rb
  def change
    add_index :cloud_records, :publisher_id
  end
end

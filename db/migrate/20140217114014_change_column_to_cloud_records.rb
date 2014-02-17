class ChangeColumnToCloudRecords < ActiveRecord::Migration
  def up
    change_column :cloud_records,:networkInbound, :integer, :limit => 8
    change_column :cloud_records,:networkOutBound, :integer, :limit => 8
  end

  def down
  end
end

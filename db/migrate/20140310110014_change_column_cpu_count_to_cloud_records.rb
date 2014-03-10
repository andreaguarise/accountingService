class ChangeColumnCpuCountToCloudRecords < ActiveRecord::Migration
  def up
    change_column :cloud_records,:cpuCount, :decimal, :precision => 8, :scale => 2
  end

  def down
  end
end

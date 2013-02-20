class CreateCloudRecords < ActiveRecord::Migration
  def change
    create_table :cloud_records do |t|
      t.string :VMUUID
      t.integer :resource_id
      t.string :localVMID
      t.string :local_user
      t.string :local_group
      t.string :globaluserName
      t.string :FQAN
      t.string :status
      t.timestamp :startTime
      t.timestamp :endTime
      t.integer :suspendDuration
      t.integer :wallDuration
      t.integer :cpuDuration
      t.integer :cpuCount
      t.string :networkType
      t.integer :networkInbound
      t.integer :networkOutBound
      t.integer :memory
      t.integer :disk
      t.string :storageRecordId
      t.string :diskImage
      t.string :cloudType

      t.timestamps
    end
  end
end

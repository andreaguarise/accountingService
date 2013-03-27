class CreateEmiStorageRecords < ActiveRecord::Migration
  def change
    create_table :emi_storage_records do |t|
      t.string :recordIdentity
      t.string :storageSystem
      t.string :site
      t.string :storageShare
      t.string :storageMedia
      t.string :storageClass
      t.integer :fileCount
      t.string :directoryPath
      t.string :localUser
      t.string :localGroup
      t.string :userIdentity
      t.string :group
      t.string :groupAttribute
      t.string :attributeType
      t.datetime :startTime
      t.datetime :endTime
      t.integer :resourceCapacityUsed
      t.integer :logicalCapacityUsed
      t.integer :resourceCapacityAllocated

      t.timestamps
    end
  end
end

class CreateStorageSummaryOnes < ActiveRecord::Migration
  def change
    create_table :storage_summary_ones do |t|
      t.date :date
      t.string :publisher_id
      t.string :site
      t.string :storageSystem
      t.integer :resourceCapacityAllocated, :limit => 8
      t.integer :resourceCapacityUsed, :limit => 8
      t.integer :logicalCapacityUsed, :limit => 8
      t.integer :storageClass

      t.timestamps
    end
  end
end

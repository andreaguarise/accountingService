class CreateStorageSummaries < ActiveRecord::Migration
  def change
    create_table :storage_summaries do |t|
      t.date :date
      t.string :publisher_id
      t.string :site
      t.string :storageSystem
      t.string :group
      t.integer :resourceCapacityUsed, :limit => 8
      t.integer :logicalCapacityUsed, :limit => 8
      t.string :storageShare

      t.timestamps
    end
  end
end

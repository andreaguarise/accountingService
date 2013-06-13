class AddResourceCapacityAllocatedToStorageSummary < ActiveRecord::Migration
  def change
    add_column :storage_summaries, :resourceCapacityAllocated, :integer, :limit => 8
  end
end

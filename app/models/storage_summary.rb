class StorageSummary < ActiveRecord::Base
  attr_accessible :date, :group, :logicalCapacityUsed, :publisher_id, :resourceCapacityAllocated, :resourceCapacityUsed, :site, :storageShare, :storageSystem
end

class StorageSummaryOne < ActiveRecord::Base
  attr_accessible :date, :logicalCapacityUsed, :publisher_id, :resourceCapacityAllocated, :resourceCapacityUsed, :site, :storageClass, :storageSystem
end

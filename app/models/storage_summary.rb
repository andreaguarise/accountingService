class StorageSummary < ActiveRecord::Base
  include Search
  attr_accessible :date, :group, :logicalCapacityUsed, :publisher_id, :resourceCapacityAllocated, :resourceCapacityUsed, :site, :storageShare, :storageSystem
end

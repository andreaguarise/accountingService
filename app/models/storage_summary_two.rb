class StorageSummaryTwo < ActiveRecord::Base
  attr_accessible :date, :group, :logicalCapacityUsed, :publisher_id, :resourceCapacityUsed, :site, :storageClass, :storageSystem
end

class EmiStorageRecord < ActiveRecord::Base
  attr_accessible :attributeType, :directoryPath, :endTime, :fileCount, :group, :groupAttribute, :localGroup, :localUser, :logicalCapacityUsed, :recordIdentity, :resourceCapacityAllocated, :resourceCapacityUsed, :site, :startTime, :storageClass, :storageMedia, :storageShare, :storageSystem, :userIdentity
end

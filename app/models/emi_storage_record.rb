class EmiStorageRecord < ActiveRecord::Base
  attr_accessible :attributeType, :directoryPath, :endTime, :fileCount, :group, :groupAttribute, :localGroup, :localUser, :logicalCapacityUsed, :publisher_id, :recordIdentity, :resourceCapacityAllocated, :resourceCapacityUsed, :site, :startTime, :storageClass, :storageMedia, :storageShare, :storageSystem, :userIdentity
  validates :publisher_id, :presence => true, :on => :create
  validates :recordIdentity, :presence => true, :uniqueness => true, :on => :create
  belongs_to :publisher
  delegate :resource, :to => :publisher
  #delegate :site, :to => :resource
end

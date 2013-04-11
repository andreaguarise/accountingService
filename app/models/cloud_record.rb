class CloudRecord < ActiveRecord::Base
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :publisher_id, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  belongs_to :publisher
  belongs_to :resource #FIXME association should be removed since this will go through publisher->resource
  validates :VMUUID, :presence => true, :uniqueness => true, :on => :create
  validates :resource_id, :presence => true, :on => :create
  validates :publisher_id, :presence => true, :on => :create
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource #FIXME this should go through the delegate :resource, check.
end

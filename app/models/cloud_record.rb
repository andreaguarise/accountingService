class CloudRecord < ActiveRecord::Base
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :publisher_id, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  belongs_to :publisher
  validates :VMUUID, :presence => true, :uniqueness => true, :on => :create
  validates :publisher_id, :presence => true, :on => :create
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

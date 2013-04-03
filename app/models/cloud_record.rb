class CloudRecord < ActiveRecord::Base
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  belongs_to :resource
  validates :VMUUID, :presence => true, :uniqueness => true, :on => :create
  validates :resource_id, :presence => true, :on => :create
  delegate :site, :to => :resource
end

class CloudRecord < ActiveRecord::Base
  include Search
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :publisher_id, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  before_create :translateDates
  belongs_to :publisher
  validates :VMUUID, :presence => true, :uniqueness => true, :on => :create
  validates :publisher_id, :presence => true, :on => :create
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  protected

  def translateDates
    logger.info "translateDates, startTime:#{self.startTime_before_type_cast}, endTime:#{self.attributes["endTime"]}"
    if /[[:digit:]]{10}/.match(self.endTime_before_type_cast.to_s) 
      logger.info "endTime:#{self.endTime_before_type_cast.to_s} --> "
      self.endTime = Time.at(self.endTime_before_type_cast.to_i)
    end
    if /[[:digit:]]{10}/.match(self.startTime_before_type_cast.to_s)
      logger.info "startTime:#{self.startTime_before_type_cast.to_s} --> " 
      self.startTime = Time.at(self.startTime_before_type_cast.to_i)
    end
    #self.uniqueId = self.recordDate.to_s + "-" + self.lrmsId
  end
  
end

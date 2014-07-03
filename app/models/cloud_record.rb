class CloudRecord < ActiveRecord::Base
  #:memory -> MBytes
  #:networkInbound, :networkOutbound -> Bytes
  include Search
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :hypervisor_hostname, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :publisher_id, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  before_create :translateDates
  belongs_to :publisher
  validates :VMUUID, :presence => true, :on => :create
  validates :publisher_id, :presence => true, :on => :create
  has_one :resource, :through => :publisher
  has_one :site, :through => :resource
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  @attr_searchable =["publishers.hostname", "resources.name", "sites.name", "VMUUID", "diskImage", "localVMID", "local_group", "local_user","status","hypervisor_hostname"]
  @date_searchable = ["endTime"]
  @terminal_state =["EPILOG","CLEANUP","DONE","FAIL"]
  
  def self.attrSearchable
    @attr_searchable  
  end
  
  def self.terminal_state
    @terminal_state
  end

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
  end

end

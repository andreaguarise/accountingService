class CloudRecord < ActiveRecord::Base
  include Search
  attr_accessible :FQAN, :VMUUID, :cloudType, :cpuCount, :cpuDuration, :disk, :diskImage, :endTime, :globaluserName, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutBound, :networkType, :publisher_id, :resource_id, :startTime, :status, :storageRecordId, :suspendDuration, :wallDuration
  before_create :translateDates
  belongs_to :publisher
  #validates :VMUUID, :presence => true, :uniqueness => true, :on => :create
  validates :VMUUID, :presence => true, :on => :create
  validates :publisher_id, :presence => true, :on => :create
  has_one :resource, :through => :publisher
  has_one :site, :through => :resource
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  @attr_searchable =["VMUUID", "diskImage", "localVMID", "local_group", "local_user","status"]
  
  def self.attrSearchable
    @attr_searchable  
  end
  
  def self.produceSummaries
    sites = self.joins(:publisher,:resource,:site).select("count(*),sites.id as site_id").group("site_id")
    groups = self.select(:local_group).uniq
    users = self.select(:local_user).uniq

    

    #ary = self.joins(:publisher,:resource,:site).select("date(startTime) as d0, date(endTime) as d1, sites.name as sn, wallDuration as w, networkInbound as netIn, networkOutBound as netOut, cpuCount as cpuN").where("sites.name = ?",site.site_name).all
    ary = self.joins(:publisher,:resource,:site).select("date(startTime) as d0, date(endTime) as d1, date(cloud_records.updated_at) as d2, sites.id as si, local_group as lg, local_user as lu, wallDuration as w, networkInbound as netIn, networkOutBound as netOut, cpuCount as cpuN, memory as memory").all
    
    sites.each do |site|
    users.each do |user|
    groups.each do |group|
      
      wallH = {}
      netInH = {}
      netOutH = {}
      cpuCountH = {}
      vmCountH = {}
      memoryH = {}
      ary.each do |r|
        next if group.local_group != r[:lg]
        next if user.local_user != r[:lu]
        next if site.site_id != r[:si]
        #puts "#{group.local_group} -- #{user.local_user}"
        if not r[:d1] 
          r[:d1] = r[:d2] ##Running vms: use record update time instead of vm end time
        end
        dRange = (r[:d0].to_date..r[:d1].to_date)
        dRange.each do |d|
          buffWall = 0.0
          buffWall = wallH[d] if wallH[d]
          buffNetIn = 0.0
          buffNetIn = netInH[d] if netInH[d]
          buffNetOut = 0.0
          buffNetOut = netOutH[d] if netOutH[d]
          buffCpuCount = 0
          buffCpuCount = cpuCountH[d] if cpuCountH[d]
          buffVmCount = 0
          buffVmCount = vmCountH[d] if vmCountH[d]
          buffMemory = 0.0
          buffMemory = memoryH[d] if memoryH[d]
          wallH[d] = (r[:w]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffWall if ((r[:d1].to_date-r[:d0].to_date) != 0)
          netInH[d] = (r[:netIn]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffNetIn if ((r[:d1].to_date-r[:d0].to_date) != 0)
          netOutH[d] = (r[:netOut]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffNetOut if ((r[:d1].to_date-r[:d0].to_date) != 0)
          cpuCountH[d] = r[:cpuN] + buffCpuCount if r[:cpuN]
          memoryH[d] = r[:memory] + buffMemory if r[:memory]
          vmCountH[d] = 1 + buffVmCount
        end
      end
      i=0
      wallH.sort.each do |k,wallTime|
        i = i +1
        puts "#{i} group: #{site.site_id}, # group: #{group.local_group}, user:#{user.local_user} - date: #{k}: #{wallTime}, #{netInH[k]}, #{netOutH[k]}, #{cpuCountH[k]}, #{vmCountH[k]}, #{memoryH[k]}"
        
        newSummaryLine = CloudRecordSummary.new
        newSummaryLine.date = k
        newSummaryLine.site_id = site.site_id
        newSummaryLine.local_group = group.local_group
        newSummaryLine.local_user = user.local_user
        newSummaryLine.cpuCount = cpuCountH[k]
        newSummaryLine.memory = memoryH[k]
        newSummaryLine.networkInBound = netInH[k]
        newSummaryLine.networkOutBound = netOutH[k]
        newSummaryLine.vmCount = vmCountH[k]
        newSummaryLine.wallDuration = wallTime
        newSummaryLine.save #INSERT if new
        if not newSummaryLine.valid?
          oldRecord = CloudRecordSummary.where(:date => newSummaryLine.date, :site_id =>newSummaryLine.site_id, :local_group => newSummaryLine.local_group, :local_user => newSummaryLine.local_user ).first
          oldRecord.update_attributes(newSummaryLine.attributes.except("id", "created_at", "updated_at"))     
          oldRecord.save #UPDATE since it exists
        end
      end      
      #end

    end
    end
    end
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
  #self.uniqueId = self.recordDate.to_s + "-" + self.lrmsId
  end

end

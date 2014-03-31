class CloudRecordUserSummary < CloudRecordSummary
  attr_accessible :cpuCount, :date, :local_group, :local_user, :memory, :networkInbound, :networkOutbound, :site_id, :vmCount, :wallDuration
  
  @attr_searchable =["sites.name","local_group", "local_user", "status"]
  @date_searchable = ["date"]
  
  def self.attrSearchable
    @attr_searchable  
  end
  
  def self.dateSearchable
    @date_searchable
  end

end

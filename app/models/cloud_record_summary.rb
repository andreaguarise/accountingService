class CloudRecordSummary < ActiveRecord::Base
  include Search
  attr_accessible :cpuCount, :date, :hour, :local_group, :local_user, :memory, :networkInbound, :networkOutbound, :site_id, :vmCount, :wallDuration, :cpuDuration, :status
  #validates_uniqueness_of :date, :scope =>[:site_id,:local_group,:local_user]
  belongs_to :site
  
  
  @attr_searchable =["sites.name","local_group", "local_user", "status"]
  @date_searchable = ["date"]
  
  def self.attrSearchable
    @attr_searchable  
  end
  
  def self.dateSearchable
    @date_searchable
  end
end

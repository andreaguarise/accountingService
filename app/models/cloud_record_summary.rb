class CloudRecordSummary < ActiveRecord::Base
  include Search
  attr_accessible :cpuCount, :date, :local_group, :local_user, :memory, :networkInBound, :networkOutBound, :site_id, :vmCount, :wallDuration
  validates_uniqueness_of :date, :scope =>[:site_id,:local_group,:local_user]
  belongs_to :site
  
  
  @attr_searchable =["local_group", "local_user"]
  
  def self.attrSearchable
    @attr_searchable  
  end
end

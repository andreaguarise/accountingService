class CpuGridSummary < ActiveRecord::Base
  include Search
  attr_accessible :fqan, :benchmark_type_id, :benchmark_value, :cpuDuration, :date, :publisher_id, :records, :globalUserName, :vo, :wallDuration
  belongs_to :publisher
  belongs_to :benchmark_type
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
    
  @attr_searchable =["publishers.hostname", "sites.name", "globalUserName", "vo", "fqan"]
  
  def self.attrSearchable
    @attr_searchable  
  end

end

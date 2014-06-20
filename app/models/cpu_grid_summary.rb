class CpuGridSummary < ActiveRecord::Base
  include Search
  attr_accessible :FQAN, :benchmark_type_id, :benchmark_value, :cput, :date, :publisher_id, :records, :userDN, :vo, :wallt
  belongs_to :publisher
  belongs_to :benchmark_type
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
    
  @attr_searchable =["publishers.hostname", "sites.name", "userDN", "vo", "FQAN"]
  
  def self.attrSearchable
    @attr_searchable  
  end

end

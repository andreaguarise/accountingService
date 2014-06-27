class CpuGridNormRecord < ActiveRecord::Base
  include Search
  attr_accessible :fqan, :benchmark_value_id, :cpuDuration, :machineName, :submitHost, :localUserId, :localJobId, :nodeCount, :processors, :memoryReal, :publisher_id, :recordDate, :globalUserName, :memoryVirtual, :vo, :voGroup, :voRole, :wallDuration, :queue, :startTime, :endTime, :infrastructureDescription, :infrastructureType
  belongs_to :publisher
  belongs_to :benchmark_value
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  @attr_searchable =["publishers.hostname", "sites.name", "vo", "localUserId"]
  
  def self.attrSearchable
    @attr_searchable  
  end
end

class DgasGridCpuRecord < ActiveRecord::Base
  attr_accessible :FQAN, :cpuTime, :dgJobId, :endDate, :executingNodes, :fBench, :fBenchType, :globaluserName, :iBenchType, :local_group, :local_user, :lrmsID, :numNodes, :pmem, :resource_id, :startDate, :uniqueChecksum, :urSource, :userVO, :vmem, :voOrigin, :wallTime
  belongs_to :resource
  delegate :site, :to => :resource
end

class EmiComputeAccountingRecord < ActiveRecord::Base
  attr_accessible :ceCertificateSubject, :ceHost, :charge, :cpuDuration, :createTime, :dgasAccountingProcedure, :endTime, :execHost, :globalJobId, :globalUserName, :group, :jobName, :localJobId, :localUserId, :machineName, :physicalMemory, :projectName, :queue, :recordId, :serviceLevelFloatBench, :serviceLevelFloatBenchType, :serviceLevelIntBench, :serviceLevelIntBenchType, :startTime, :status, :timeInstantCtime, :timeInstantETime, :timeInstantQTime, :virtualMemory, :voOrigin, :vomsFQAN, :wallDuration
  validates :recordId, :presence => true, :uniqueness => true
end

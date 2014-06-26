class ApelSsmRecord < ActiveRecord::Base
  attr_accessible :cpuDuration, :endTime, :fqan, :globalUserName, :infrastructureDescription, :infrastructureType, :localJobId, :localUserId, :machineName, :memoryReal, :memoryVirtual, :nodeCount, :processors, :publisher_id, :queue, :recordDate, :startTime, :submitHost, :vo, :voGroup, :voRole, :wallDuration
end

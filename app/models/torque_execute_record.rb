class TorqueExecuteRecord < ActiveRecord::Base
  attr_accessible :ctime, :end, :etime, :execHost, :exitStatus, :group, :jobName, :lrmsId, :qtime, :queue, :recordDate, :resourceList_walltime, :resourceList_nodect, :resourceList_nodes, :resourceUsed_cput, :resourceUsed_mem, :resourceUsed_vmem, :resourceUsed_walltime, :session, :start, :uniqueId, :user
end

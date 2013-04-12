class TorqueExecuteRecord < ActiveRecord::Base
  attr_accessible :ctime, :end, :etime, :execHost, :exitStatus, :group, :jobName, :lrmsId, :publisher_id, :qtime, :queue, :recordDate, :resourceList_walltime, :resourceList_nodect, :resourceList_nodes, :resourceUsed_cput, :resourceUsed_mem, :resourceUsed_vmem, :resourceUsed_walltime, :session, :start, :uniqueId, :user
  validates :publisher_id, :presence => true, :on => :create
  belongs_to :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

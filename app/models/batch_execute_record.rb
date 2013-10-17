class BatchExecuteRecord < ActiveRecord::Base
  include Search
  attr_accessible :ctime, :end, :etime, :execHost, :exitStatus, :localGroup, :jobName, :lrmsId, :publisher_id, :qtime, :queue, :recordDate, :resourceList_walltime, :resourceList_nodect, :resourceList_nodes, :resourceUsed_cput, :resourceUsed_mem, :resourceUsed_vmem, :resourceUsed_walltime, :session, :start, :uniqueId, :localUser
  before_validation :computeUniqueId
  validates :publisher_id, :presence => true, :on => :create
  validates :uniqueId, :uniqueness => true, :on => :create
  has_many :grid_cpu_record
  has_many :benchmark_values, :through => :publisher
  belongs_to :publisher
  delegate :benchmark_value, :to => :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  public

  def computeUniqueId
    self.uniqueId = self.recordDate.to_s + "-" + self.lrmsId
  end
end



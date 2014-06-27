class ApelSsmRecord < ActiveRecord::Base
  include Search
  attr_accessible :cpuDuration, :endTime, :fqan, :globalUserName, :infrastructureDescription, :infrastructureType, :localJobId, :localUserId, :machineName, :memoryReal, :memoryVirtual, :nodeCount, :processors, :publisher_id, :queue, :recordDate, :startTime, :submitHost, :vo, :voGroup, :voRole, :wallDuration
  validates :publisher_id, :presence => true, :on => :create
  validates_uniqueness_of :localJobId, :scope => :recordDate
  has_many :benchmark_values, :through => :publisher
  belongs_to :publisher
  delegate :benchmark_value, :to => :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

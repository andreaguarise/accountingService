class BlahRecord < ActiveRecord::Base
  attr_accessible :ceId, :clientId, :jobId, :localUser, :lrmsId, :publisher_id, :recordDate, :timestamp, :uniqueId, :userDN, :userFQAN
  before_validation :computeUniqueId
  validates :publisher_id, :presence => true, :on => :create
  validates :uniqueId, :uniqueness => true, :on => :create
  has_many :grid_cpu_records
  belongs_to :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource

protected

def computeUniqueId
    self.uniqueId = self.recordDate.to_s + "-" + self.lrmsId
end

end

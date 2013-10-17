class BlahRecord < ActiveRecord::Base
  include Search
  attr_accessible :ceId, :clientId, :jobId, :localUser, :lrmsId, :publisher_id, :recordDate, :timestamp, :uniqueId, :userDN, :userFQAN
  before_validation :computeUniqueId
  belongs_to :publisher
  validates :publisher_id, :presence => true, :on => :create
  validates :uniqueId, :uniqueness => true, :on => :create
  has_one :grid_cpu_record, :dependent => :destroy
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource

public

def computeUniqueId
    self.uniqueId = self.recordDate.to_s + "-" + self.lrmsId
end

end

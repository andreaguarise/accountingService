class BlahRecord < ActiveRecord::Base
  attr_accessible :ceId, :clientId, :jobId, :localUser, :lrmsId, :publisher_id, :recordDate, :timestamp, :uniqueId, :userDN, :userFQAN
  validates :publisher_id, :presence => true, :on => :create
  belongs_to :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

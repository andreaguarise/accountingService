class TorqueQueueRecord < ActiveRecord::Base
  attr_accessible :lrmsId, :queue, :recordDate, :uniqueId, :publisher_id
  validates :publisher_id, :presence => true, :on => :create
  belongs_to :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

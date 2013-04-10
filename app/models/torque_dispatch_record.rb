class TorqueDispatchRecord < ActiveRecord::Base
  attr_accessible :lrmsId, :recordDate, :requestor, :uniqueId, :publisher_id
  validates :publisher_id, :presence => true, :on => :create
  belongs_to :publisher
end

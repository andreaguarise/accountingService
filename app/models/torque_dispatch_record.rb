class TorqueDispatchRecord < ActiveRecord::Base
  attr_accessible :lrmsId, :recordDate, :requestor, :uniqueId, :publisher_id
  belongs_to :publisher
end

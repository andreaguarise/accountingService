class GridPledge < ActiveRecord::Base
  attr_accessible :benchmark_type_id, :logicalCPU, :physicalCPU, :publisher_id, :validFrom, :validTo, :value
  validates_uniqueness_of :validFrom, :scope =>[:publisher_id]
  belongs_to :benchmark_type
  belongs_to :publisher

  delegate :resource, :to => :publisher
end

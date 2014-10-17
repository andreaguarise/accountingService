class GridPledge < ActiveRecord::Base
  attr_accessible :benchmark_type_id, :logicalCPU, :physicalCPU, :site_id, :validFrom, :validTo, :value

  validates_uniqueness_of :validFrom, :scope =>[:site_id]
  belongs_to :benchmark_type
  belongs_to :site

end

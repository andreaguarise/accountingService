class CpuGridNormRecord < ActiveRecord::Base
  include Search
  attr_accessible :FQAN, :benchmark_value_id, :cput, :execHost, :localUser, :lrmsId, :nodect, :nodes, :pmem, :publisher_id, :recordDate, :userDN, :vmem, :vo, :voGroup, :voRole, :wallt
  belongs_to :publisher
  belongs_to :benchmark_value
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
end

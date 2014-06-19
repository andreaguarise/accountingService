class CpuGridNormRecord < ActiveRecord::Base
  attr_accessible :FQAN, :benchmark_value_id, :cput, :execHost, :localUser, :lrmsId, :nodect, :nodes, :pmem, :publisher_id, :recordDate, :userDN, :vmem, :vo, :voGroup, :voRole, :wallt
end

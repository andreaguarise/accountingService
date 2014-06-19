class CpuGridSummary < ActiveRecord::Base
  attr_accessible :FQAN, :benchmark_type_id, :benchmark_value, :cput, :date, :publisher_id, :records, :userDN, :vo, :wallt
end

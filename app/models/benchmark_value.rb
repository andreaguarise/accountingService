class BenchmarkValue < ActiveRecord::Base
  attr_accessible :benchmark_type_id, :date, :publisher_id, :value
end

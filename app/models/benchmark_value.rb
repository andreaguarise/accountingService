class BenchmarkValue < ActiveRecord::Base
  attr_accessible :benchmark_type_id, :date, :publisher_id, :value
  belongs_to :benchmark_type
  belongs_to :publisher 
  has_many :batch_execute_record, :through => :publisher
  
  delegate :resource, :to => :publisher 
end

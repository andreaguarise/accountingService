class BenchmarkValue < ActiveRecord::Base
  include Search
  attr_accessible :benchmark_type_id, :date, :publisher_id, :value
  belongs_to :benchmark_type
  belongs_to :publisher 
  has_many :batch_execute_record, :through => :publisher
  has_many :local_cpu_summary, :through => :publisher
  
  delegate :resource, :to => :publisher 
end

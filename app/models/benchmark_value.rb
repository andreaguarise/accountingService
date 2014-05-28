class BenchmarkValue < ActiveRecord::Base
  include Search
  attr_accessible :benchmark_type_id, :date, :publisher_id, :value
  before_create :shouldInsert?
  belongs_to :benchmark_type
  belongs_to :publisher
  has_many :batch_execute_record, :through => :publisher
  has_many :local_cpu_summary, :through => :publisher
  
  delegate :resource, :to => :publisher 
  
  def shouldInsert?
    bv = BenchmarkValue.where(:publisher_id => self.publisher_id).order(:date).last
    if bv != nil
      (self.date.to_i - bv.date.to_i).abs > 86400
    else
      true
    end 
  end
  
end

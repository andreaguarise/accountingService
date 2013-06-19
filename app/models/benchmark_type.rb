class BenchmarkType < ActiveRecord::Base
  include Search
  attr_accessible :description, :name
  has_many :benchmark_values
  
end

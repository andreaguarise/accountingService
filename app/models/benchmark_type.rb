class BenchmarkType < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :benchmark_values
end

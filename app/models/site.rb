class Site < ActiveRecord::Base
  include Search
  attr_accessible :description, :name
  has_many :resources, :dependent => :destroy
  has_many :publishers, :through => :resources
  has_many :cloud_records, :through => :resources
  has_many :blah_records, :through => :resources
  has_many :batch_execute_records, :through => :resources
  has_many :local_cpu_records, :through => :resources
  validates :name, :presence => true, :uniqueness => true, :on => :create
  
  
  
end

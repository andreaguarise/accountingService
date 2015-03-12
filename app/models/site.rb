class Site < ActiveRecord::Base
  include Search
  attr_accessible :description, :name, :type, :enabled
  has_many :resources, :dependent => :destroy
  has_many :publishers, :through => :resources
  has_many :cloud_records, :through => :resources
  has_many :apel_ssm_records, :through => :resources
  has_many :batch_execute_records, :through => :resources
  has_many :local_cpu_records, :through => :resources
  has_many :cloud_record_summaries, :dependent => :destroy
  has_many :grid_pledges, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true, :on => :create
  
end

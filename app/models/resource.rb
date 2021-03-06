class Resource < ActiveRecord::Base
  include Search
  attr_accessible :description, :name, :resource_type_id, :site_id, :resource_type_name, :site_name
  validates :site_id, :presence => true, :on => :create
  validates :resource_type_id, :presence => true, :on => :create
  validates :name, :presence => true, :uniqueness => true, :on => :create
  
  has_many :publishers, :dependent => :destroy
   
  has_many :dgas_grid_cpu_records 
  has_many :local_cpu_summaries, :through => :publishers
  has_many :grid_cpu_records, :through => :publishers
  has_many :cloud_records, :through => :publishers
  has_many :apel_ssm_records, :through => :publishers
  has_many :batch_execute_records, :through => :publishers
  has_many :emi_storage_records, :through => :publishers
  has_many :database_schemes, :through => :publishers
  belongs_to :resource_type
  belongs_to :site
  
  accepts_nested_attributes_for :site
end

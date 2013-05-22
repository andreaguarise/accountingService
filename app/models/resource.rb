class Resource < ActiveRecord::Base
  attr_accessible :description, :name, :resource_type_id, :site_id
  validates :site_id, :presence => true, :on => :create
  validates :resource_type_id, :presence => true, :on => :create
  validates :name, :presence => true, :uniqueness => true, :on => :create
  has_many :publishers
   
  has_many :dgas_grid_cpu_records 
  has_many :grid_cpu_records, :through => :publishers
  has_many :cloud_records, :through => :publishers
  has_many :blah_records, :through => :publishers
  has_many :torque_execute_records, :through => :publishers
  has_many :emi_storage_records, :through => :publishers
  #has_many :emi_storage_records #FIXME this should be removed since association will be through the publisher
  belongs_to :resource_type
  belongs_to :site
end

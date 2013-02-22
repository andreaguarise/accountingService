class Resource < ActiveRecord::Base
  attr_accessible :description, :name, :resource_type_id, :site_id
  has_many :cloud_records
  has_many :dgas_grid_cpu_records
  belongs_to :resource_type
  belongs_to :site
end

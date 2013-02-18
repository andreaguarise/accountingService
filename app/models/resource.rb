class Resource < ActiveRecord::Base
  attr_accessible :description, :name, :resource_type_id, :site_id
  belongs_to :ResourceType
  belongs_to :Site
end

class DatabaseScheme < ActiveRecord::Base
  attr_accessible :name, :publisher_id
  
  belongs_to :publisher
  has_one :database_descr
end

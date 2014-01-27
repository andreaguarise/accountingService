class DatabaseScheme < ActiveRecord::Base
  attr_accessible :name, :publisher_id
  
  belongs_to :publisher
end

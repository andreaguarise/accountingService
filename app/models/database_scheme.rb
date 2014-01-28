class DatabaseScheme < ActiveRecord::Base
  attr_accessible :name, :publisher_id, :database_descr_id
  
  belongs_to :publisher
  belongs_to :database_descr
  
  has_many :database_table
end



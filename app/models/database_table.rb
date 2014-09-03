class DatabaseTable < ActiveRecord::Base
  attr_accessible :database_scheme_id, :name
  
  belongs_to :database_scheme
  
  
  has_many :database_record
end

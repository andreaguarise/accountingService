class DatabaseDescr < ActiveRecord::Base
  attr_accessible :backend, :version
  
  has_many :database_scheme
end

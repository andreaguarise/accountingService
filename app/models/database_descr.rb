class DatabaseDescr < ActiveRecord::Base
  attr_accessible :backend, :backendVersion, :database_scheme_id
  
  belongs_to :database_scheme
end

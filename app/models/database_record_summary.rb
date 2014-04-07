class DatabaseRecordSummary < ActiveRecord::Base
  include Search
  attr_accessible :database_descr_id, :indexsize, :publisher_id, :record_date, :rows, :scheme_name, :table_name, :tablesize
  
  belongs_to :database_descr
  belongs_to :publisher
  has_one :resource, :through => :publisher
  has_one :site, :through => :resource
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
end

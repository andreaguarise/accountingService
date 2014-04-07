class DatabaseRecordSummary < ActiveRecord::Base
  attr_accessible :database_descr_id, :indexsize, :publisher_id, :record_date, :rows, :scheme_name, :table_name, :tablesize
  
  belongs_to :database_scheme
  belongs_to :publisher
  
end

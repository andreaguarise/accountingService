class DatabaseRecord < ActiveRecord::Base
  attr_accessible :database_table_id, :indexsize, :rows, :tablesize, :time, :schema, :table
  
  belongs_to :database_table
end

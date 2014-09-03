class DatabaseRecord < ActiveRecord::Base
  attr_accessible :database_table_id, :indexsize, :rows, :tablesize, :time, :schema, :table
  
  belongs_to :database_table
  
  @attr_searchable =["database_table.name"]
  @date_searchable = ["endTime"]
  
  def self.attrSearchable
    @attr_searchable  
  end
end

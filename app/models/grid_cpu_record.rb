class GridCpuRecord < ActiveRecord::Base
  #after_initialize :readonly!
  include Search
  attr_accessible :blah_record_id, :batch_execute_record_id
  belongs_to :batch_execute_record
  belongs_to :blah_record
  validates :blah_record_id, :presence => true, :uniqueness => true, :on => :create
  delegate :publisher, :to => :blah_record
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  @attr_searchable =["publishers.hostname", "resources.name", "sites.name", "blah_records.userDN", "batch_execute_records.localUser"]
  
  def self.attrSearchable
    @attr_searchable  
  end
  
end

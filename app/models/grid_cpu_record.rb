class GridCpuRecord < ActiveRecord::Base
  attr_accessible :blah_record_id, :batch_execute_record_id
  belongs_to :batch_execute_record
  belongs_to :blah_record
  validates :blah_record_id, :presence => true, :uniqueness => true, :on => :create
  delegate :publisher, :to => :blah_record
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
end

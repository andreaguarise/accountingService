class GridCpuRecord < ActiveRecord::Base
  attr_accessible :blah_record_id, :recordlike_id, :recordlike_type
  belongs_to :recordlike ,:polymorphic => true
  belongs_to :blah_record
  validates :blah_record_id, :presence => true, :uniqueness => true, :on => :create
  delegate :publisher, :to => :blah_record
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
end

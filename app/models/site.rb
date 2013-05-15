class Site < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :resources, :dependent => :destroy
  has_many :cloud_records, :through => :resources
  validates :name, :presence => true, :uniqueness => true, :on => :create
end

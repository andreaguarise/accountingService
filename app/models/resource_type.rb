class ResourceType < ActiveRecord::Base
  include Search
  attr_accessible :name, :description
  has_many :resources, :dependent => :destroy
  has_many :publishers, :through => :resources
  validates :name, :presence => true, :uniqueness => true, :on => :create
end

class ResourceType < ActiveRecord::Base
  include Search
  attr_accessible :name
  has_many :resources, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true, :on => :create
end

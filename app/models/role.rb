class Role < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :users, :dependent => :destroy
  validates :name, :presence => true, :on => :create
end

class Role < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :users, :dependent => :destroy
  validates :name, :presence => true, :on => :create
  before_destroy :ensure_admin_remains
  
  
  
  
end


def ensure_admin_remains 
      if self.name == "admin"
        raise "Role: Can't delete admin role!"
      end
      if self.name == "user"
        raise "Role: Can't delete user role!"
      end
      true
  end
class Role < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :users, :dependent => :destroy
  validates :name, :presence => true, :on => :create
end


def ensure_admin_remains 
      if Role.find(params[:id]).name == "admin"
        raise "Can't delete admin role!"
      end
      if Role.find(params[:id]).name == "user"
        raise "Can't delete user role!"
      end
  end
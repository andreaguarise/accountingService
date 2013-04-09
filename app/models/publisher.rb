class Publisher < ActiveRecord::Base
  attr_accessible :hostname, :ip, :token
  validates :ip, :presence => true, :uniqueness => true
  has_many :torque_dispatch_records 
  has_many :torque_queue_records
  has_many :torque_execute_records
  
  before_create :generate_token
  
  def Publisher.authenticate(ip,token)
    if publisher = find_by_ip(ip)
      if publisher.token == token
        #session[:publisher_id] = publisher.id
        publisher
      end
    end
  end
  
  protected
  
  def generate_token
    self.token = self.object_id.to_s + rand.to_s
  end
  
end

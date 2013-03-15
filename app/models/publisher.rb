class Publisher < ActiveRecord::Base
  attr_accessible :hostname, :ip, :token
  validates :ip, :presence => true, :uniqueness => true
  
  before_create :generate_token
  
  def Publisher.authenticate(ip,token)
    if publisher = find_by_ip(ip)
      if publisher.token == token
        publisher
      end
    end
  end
  
  protected
  
  def generate_token
    self.token = self.object_id.to_s + rand.to_s
  end
  
end

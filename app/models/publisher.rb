class Publisher < ActiveRecord::Base
  include Search
  attr_accessible :hostname, :ip, :token, :resource_id, :resource_name
  #validates :ip, :presence => true, :uniqueness => true
  validates :ip, :presence => true
  validates :resource_id, :presence => true, :on => :create
  validates_uniqueness_of :hostname, :scope => :resource_id
  belongs_to :resource 
  has_many :apel_ssm_records, :dependent => :delete_all
  has_many :cloud_records, :dependent => :destroy 
  has_many :local_cpu_summaries, :dependent => :destroy
  has_many :batch_execute_records, :dependent => :delete_all
  has_many :emi_storage_records, :dependent => :destroy
  has_many :benchmark_values, :dependent => :destroy
  has_many :database_schemes, :dependent => :destroy
  has_many :cpu_grid_norm_records
  has_many :cpu_grid_summaries
  
  accepts_nested_attributes_for :resource
  delegate :site, :to => :resource
  delegate :resource_type, :to => :resource
  
  before_create :generate_token
  
  def Publisher.authenticate(ip,token)
    #if publisher = find_by_ip(ip)
      #if publisher.token == token
    if publisher = find_by_token(token)
      if publisher.ip == ip
        publisher
      end
    end
  end
  
  protected
  
  def generate_token
    self.token = self.object_id.to_s + rand.to_s
  end
  
end

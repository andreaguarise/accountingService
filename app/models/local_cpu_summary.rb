class LocalCpuSummary < ActiveRecord::Base
  attr_accessible :date, :localGroup, :localUser, :publisher_id, :queue, :totalCpuT, :totalRecords, :totalWallT
  validates :publisher_id, :presence => true, :on => :create
  validates :date, :presence => true
  validates_uniqueness_of :date, :scope =>[:publisher_id,:localGroup,:localUser,:queue]
  has_many :benchmark_values, :through => :publisher
  belongs_to :publisher
  delegate :benchmark_value, :to => :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  def self.populate(startDate = "")
    summary = LocalCpuRecord.summary(startDate)
    summary.each do |r|
      newSummaryLine = LocalCpuSummary.new
      newSummaryLine.date = r[:eDate]
      newSummaryLine.publisher_id = r[:publisher_id]
      newSummaryLine.queue = r[:queue]
      newSummaryLine.localGroup = r[:unixGroup]
      newSummaryLine.localUser = r[:unixUser]
      newSummaryLine.totalCpuT = r[:sumCpu]
      newSummaryLine.totalRecords = r[:countRecord]
      newSummaryLine.totalWallT = r[:sumWall]
      newSummaryLine.save #INSERT if new
      if not newSummaryLine.valid?
          oldRecord = LocalCpuSummary.where(:date => newSummaryLine.date, :publisher_id =>newSummaryLine.publisher_id, :queue => newSummaryLine.queue, :localGroup => newSummaryLine.localGroup, :localUser => newSummaryLine.localUser ).first
          oldRecord.update_attributes(newSummaryLine.attributes.except("id", "created_at", "updated_at"))     
          oldRecord.save #UPDATE since it exists
      end
    end
  end
  
end

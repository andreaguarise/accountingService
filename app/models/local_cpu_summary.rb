class LocalCpuSummary < ActiveRecord::Base
  include Search
  attr_accessible :date, :localGroup, :localUser,:normalisedCpuT,:normalisedWallT, :publisher_id, :queue, :totalCpuT, :totalRecords, :totalWallT
  validates :publisher_id, :presence => true, :on => :create
  validates :date, :presence => true
  validates_uniqueness_of :date, :scope =>[:publisher_id,:localGroup,:localUser,:queue]
  has_many :benchmark_values, :through => :publisher, :autosave => false
  belongs_to :publisher
  #delegate :benchmark_value, :to => :publisher
  delegate :resource, :to => :publisher
  delegate :site, :to => :resource
  
  def self.populate(startDate = "")
    
    summary = LocalCpuRecord.summary(startDate)
    summary.each do |r|
      newSummaryLine = LocalCpuSummary.new
      newSummaryLine.date = r[:eDate]
      newSummaryLine.publisher_id = r[:publisher_id]
      newSummaryLine.queue = r[:queue]
      newSummaryLine.localGroup = r[:localGroup]
      newSummaryLine.localUser = r[:localUser]
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
  
  def self.populateAndNormalise(startDate = "")
    
    summary = LocalCpuRecord.summary(startDate)
    summary.each do |r|
      newSummaryLine = LocalCpuSummary.new
      newSummaryLine.date = r[:eDate]
      newSummaryLine.publisher_id = r[:publisher_id]
      newSummaryLine.queue = r[:queue]
      newSummaryLine.localGroup = r[:localGroup]
      newSummaryLine.localUser = r[:localUser]
      newSummaryLine.totalCpuT = r[:sumCpu]
      newSummaryLine.totalRecords = r[:countRecord]
      newSummaryLine.totalWallT = r[:sumWall]
      bvalue = newSummaryLine.benchmark_values.select { |a| a.date.to_date < newSummaryLine.date.to_date }.last
      newSummaryLine.normalisedCpuT = bvalue.value * newSummaryLine.totalCpuT if bvalue
      newSummaryLine.normalisedWallT = bvalue.value * newSummaryLine.totalWallT if bvalue
      newSummaryLine.save #INSERT if new
      if not newSummaryLine.valid?
          oldRecord = LocalCpuSummary.where(:date => newSummaryLine.date, :publisher_id =>newSummaryLine.publisher_id, :queue => newSummaryLine.queue, :localGroup => newSummaryLine.localGroup, :localUser => newSummaryLine.localUser ).first
          oldRecord.update_attributes(newSummaryLine.attributes.except("id", "created_at", "updated_at"))     
          oldRecord.save #UPDATE since it exists
      end
    end
  end
  
  def self.populateNormalisedValues(startDate = "")
    #FIXME there must be a better way to manage normalisations.
    bvalues = {}
    summaries =  []
    if startDate != ""
      summaries = LocalCpuSummary.includes(:benchmark_values).find(:all, :order => 'benchmark_values.date', :conditions => "local_cpu_summaries.date >= \"#{startDate}\"")
    else
      summaries = LocalCpuSummary.includes(:benchmark_values).find(:all, :order => 'benchmark_values.date')
    end
    summaries.each do |l|
      bvalue = l.benchmark_values.select { |a| a.date.to_date < l.date.to_date }.last
      bvalues[l.id] = bvalue.value if bvalue
    end
    LocalCpuSummary.all.each do |r|
      r.normalisedCpuT = bvalues[r.id] * r.totalCpuT if bvalues[r.id]
      r.normalisedWallT = bvalues[r.id] * r.totalWallT if bvalues[r.id]
      r.save
    end
   
  end
  
end

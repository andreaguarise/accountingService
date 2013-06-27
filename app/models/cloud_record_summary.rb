class CloudRecordSummary < ActiveRecord::Base
  attr_accessible :cpuCount, :date, :local_group, :local_user, :memory, :networkInBound, :networkOutBound, :site_id, :vmCount, :wallDuration
  validates_uniqueness_of :date, :scope =>[:site_id,:local_group,:local_user]
  belongs_to :site
end

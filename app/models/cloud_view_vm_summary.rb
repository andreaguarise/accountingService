class CloudViewVmSummary < ActiveRecord::Base
  attr_accessible :VMUUID, :cloudType, :cpuCount, :cpuDuration, :date, :disk, :diskImage, :localVMID, :local_group, :local_user, :memory, :networkInbound, :networkOutbound, :publisher_id, :status, :wallDuration
end

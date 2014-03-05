class AddHypervisorHostnameToCloudRecords < ActiveRecord::Migration
  def change
    add_column :cloud_records, :hypervisor_hostname, :string
  end
end

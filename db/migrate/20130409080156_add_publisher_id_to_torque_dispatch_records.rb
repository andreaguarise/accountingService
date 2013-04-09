class AddPublisherIdToTorqueDispatchRecords < ActiveRecord::Migration
  def change
    add_column :torque_dispatch_records, :publisher_id, :integer
  end
end

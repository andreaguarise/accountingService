class AddPublisherIdToTorqueExecuteRecords < ActiveRecord::Migration
  def change
    add_column :torque_execute_records, :publisher_id, :integer
  end
end

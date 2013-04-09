class AddPublisherIdToTorqueQueueRecords < ActiveRecord::Migration
  def change
    add_column :torque_queue_records, :publisher_id, :integer
  end
end

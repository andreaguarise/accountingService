class DropTorqueQueueRecordsTable < ActiveRecord::Migration
  def up
    drop_table :torque_queue_records
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

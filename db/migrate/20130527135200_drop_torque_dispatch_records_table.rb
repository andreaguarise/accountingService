class DropTorqueDispatchRecordsTable < ActiveRecord::Migration
  def up
    drop_table :torque_dispatch_records
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

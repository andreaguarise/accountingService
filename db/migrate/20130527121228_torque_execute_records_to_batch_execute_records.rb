class TorqueExecuteRecordsToBatchExecuteRecords < ActiveRecord::Migration
  def up
    rename_table :torque_execute_records, :batch_execute_records
  end

  def down
    rename_table :batch_execute_record, :torque_execute_records
  end
end

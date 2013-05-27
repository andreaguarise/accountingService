class RenameGridCpuRecordsRecordlikeItToBatchExecuteRecordId < ActiveRecord::Migration
  def up
    rename_column :grid_cpu_records, :recordlike_id, :batch_execute_record_id
  end

  def down
    rename_column :grid_cpu_records, :batch_execute_record_id, :recordlike_id
  end
end

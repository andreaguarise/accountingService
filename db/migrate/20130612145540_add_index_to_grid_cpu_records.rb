class AddIndexToGridCpuRecords < ActiveRecord::Migration
  def change
    add_index :grid_cpu_records, :batch_execute_record_id
  end
end

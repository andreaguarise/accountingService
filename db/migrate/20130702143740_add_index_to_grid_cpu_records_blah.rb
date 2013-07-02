class AddIndexToGridCpuRecordsBlah < ActiveRecord::Migration
  def change
    add_index :grid_cpu_records, :blah_record_id
  end
end

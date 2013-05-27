class RemoveRecordlikeTypeFromGridCpuRecords < ActiveRecord::Migration
  def up
    remove_column :grid_cpu_records, :recordlike_type
  end

  def down
    add_column :grid_cpu_records, :recordlike_type, :string
  end
end

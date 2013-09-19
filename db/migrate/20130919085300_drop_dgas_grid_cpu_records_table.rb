class DropDgasGridCpuRecordsTable < ActiveRecord::Migration
  def up
    drop_table :dgas_grid_cpu_records
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

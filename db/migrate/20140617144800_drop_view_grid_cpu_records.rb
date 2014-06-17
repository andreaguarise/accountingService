class DropViewGridCpuRecords < ActiveRecord::Migration
  def up
    CpuGridId.connection.execute('DROP VIEW `grid_cpu_records`')
  end

  def down
  end
end

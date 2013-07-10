class DropTableGridCpuRecord < ActiveRecord::Migration
  def up
    drop_table :grid_cpu_records
  end

  def down
    create_table :grid_cpu_records do |t|
      t.integer :recordlike_id
      t.string :recordlike_type
      t.integer :blah_record_id

      t.timestamps
      end
  end
end

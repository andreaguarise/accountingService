class CreateLocalCpuSummaries < ActiveRecord::Migration
  def change
    create_table :local_cpu_summaries do |t|
      t.date :date
      t.string :publisher_id
      t.integer :totalRecords
      t.integer :totalCpuT
      t.integer :totalWallT
      t.string :localUser
      t.string :localGroup
      t.string :queue

      t.timestamps
    end
  end
end

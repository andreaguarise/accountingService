class CreateGridPledges < ActiveRecord::Migration
  def change
    create_table :grid_pledges do |t|
      t.integer :publisher_id
      t.date :recordDate
      t.integer :value
      t.integer :logicalCPU
      t.integer :physicalCPU
      t.integer :benchmark_type_id

      t.timestamps
    end
  end
end

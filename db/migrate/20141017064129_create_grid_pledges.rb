class CreateGridPledges < ActiveRecord::Migration
  def change
    create_table :grid_pledges do |t|
      t.integer :site_id
      t.date :validFrom
      t.date :validTo
      t.integer :value
      t.integer :logicalCPU
      t.integer :physicalCPU
      t.integer :benchmark_type_id

      t.timestamps
    end
  end
end

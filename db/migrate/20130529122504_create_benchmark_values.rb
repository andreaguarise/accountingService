class CreateBenchmarkValues < ActiveRecord::Migration
  def change
    create_table :benchmark_values do |t|
      t.integer :benchmark_type_id
      t.float :value
      t.datetime :date
      t.integer :publisher_id

      t.timestamps
    end
  end
end

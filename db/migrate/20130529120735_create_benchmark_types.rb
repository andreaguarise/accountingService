class CreateBenchmarkTypes < ActiveRecord::Migration
  def change
    create_table :benchmark_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
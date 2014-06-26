class ChangeColumnToBenchmarkValues < ActiveRecord::Migration
  def up
    change_column :benchmark_values,:date, :date
  end

  def down
    change_column :benchmark_values,:date, :datetime
  end
end

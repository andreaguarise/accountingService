class DropStorageSummaryOnesTable < ActiveRecord::Migration
  def up
    drop_table :storage_summary_ones
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

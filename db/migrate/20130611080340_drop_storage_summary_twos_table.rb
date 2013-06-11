class DropStorageSummaryTwosTable < ActiveRecord::Migration
  def up
    drop_table :storage_summary_twos
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

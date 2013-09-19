class DropEmiComputeAccountingRecordsTable < ActiveRecord::Migration
  def up
    drop_table :emi_compute_accounting_records
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

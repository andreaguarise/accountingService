class RemoveExecCeFromEmiComputeAccountingRecord < ActiveRecord::Migration
  def up
    remove_column :emi_compute_accounting_records, :execCe
  end

  def down
    add_column :emi_compute_accounting_records, :execCe, :string
  end
end

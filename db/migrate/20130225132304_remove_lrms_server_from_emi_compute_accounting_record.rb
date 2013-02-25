class RemoveLrmsServerFromEmiComputeAccountingRecord < ActiveRecord::Migration
  def up
    remove_column :emi_compute_accounting_records, :lrmsServer
  end

  def down
    add_column :emi_compute_accounting_records, :lrmsServer, :string
  end
end

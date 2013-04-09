class AddPublisherIdToEmiComputeAccountingRecords < ActiveRecord::Migration
  def change
    add_column :emi_compute_accounting_records, :publisher_id, :integer
  end
end

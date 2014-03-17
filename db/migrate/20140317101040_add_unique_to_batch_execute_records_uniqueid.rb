class AddUniqueToBatchExecuteRecordsUniqueid < ActiveRecord::Migration
  def change
    remove_index :batch_execute_records, :uniqueId
    add_index :batch_execute_records, :uniqueId, :unique => true
  end
end

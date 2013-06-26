class AddIndexToBatchExecuteRecordsBis < ActiveRecord::Migration
  #add indexes used to speed up the queries within the populateGridCpuRecords.rb
  def change
    add_index :batch_execute_records, :uniqueId
  end
end

class AddIndexToBatchExecuteRecords < ActiveRecord::Migration
  #add indexes used to speed up the queries within the populateGridCpuRecords.rb
  def change
    add_index :batch_execute_records, :lrmsId
    add_index :batch_execute_records, :recordDate
  end
end

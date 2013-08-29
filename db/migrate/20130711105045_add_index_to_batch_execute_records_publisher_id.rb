class AddIndexToBatchExecuteRecordsPublisherId < ActiveRecord::Migration
  def change
    add_index :batch_execute_records, :publisher_id
  end
end

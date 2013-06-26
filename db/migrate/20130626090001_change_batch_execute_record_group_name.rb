class ChangeBatchExecuteRecordGroupName < ActiveRecord::Migration
  def change
   rename_column :batch_execute_records, :user, :localUser
   rename_column :batch_execute_records, :group, :localGroup
  end
end
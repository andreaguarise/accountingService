class AddUniqueToApelSsmRecords < ActiveRecord::Migration
  def up
    ApelSsmRecord.connection.execute('ALTER TABLE `apel_ssm_records` ADD UNIQUE `unique_index`(`localJobId`, `recordDate`)')
  end
  
  def down
  end
end

class DropTableBlahRecords < ActiveRecord::Migration
  def up
    BatchExecuteRecord.connection.execute('DROP TABLE `blah_records`')
  end

  def down
  end
end

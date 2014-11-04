class CreateApelSsmRecords < ActiveRecord::Migration
  def change
    if (!ActiveRecord::Base.connection.table_exists? 'apel_ssm_records')
    create_table :apel_ssm_records do |t|
      t.integer :publisher_id
      t.datetime :recordDate
      t.string :submitHost
      t.string :machineName
      t.datetime :queue
      t.string :localJobId
      t.string :localUserId
      t.string :globalUserName
      t.string :fqan
      t.string :vo
      t.integer :voGroup
      t.integer :voRole
      t.integer :wallDuration
      t.integer :cpuDuration
      t.string :processors
      t.integer :nodeCount
      t.integer :startTime
      t.integer :endTime
      t.string :infrastructureDescription
      t.string :infrastructureType
      t.integer :memoryReal
      t.integer :memoryVirtual

      t.timestamps
    end
    end
  end
end

class CreateTorqueQueueRecords < ActiveRecord::Migration
  def change
    create_table :torque_queue_records do |t|
      t.string :uniqueId
      t.datetime :recordDate
      t.string :lrmsId
      t.string :queue

      t.timestamps
    end
  end
end

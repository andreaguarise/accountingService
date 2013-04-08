class CreateTorqueDispatchRecords < ActiveRecord::Migration
  def change
    create_table :torque_dispatch_records do |t|
      t.string :uniqueId
      t.datetime :recordDate
      t.string :lrmsId
      t.string :requestor

      t.timestamps
    end
  end
end

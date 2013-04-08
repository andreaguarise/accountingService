class CreateTorqueExecuteRecords < ActiveRecord::Migration
  def change
    create_table :torque_execute_records do |t|
      t.string :uniqueId
      t.datetime :recordDate
      t.string :lrmsId
      t.string :user
      t.string :group
      t.string :jobName
      t.string :queue
      t.integer :ctime
      t.integer :qtime
      t.integer :etime
      t.integer :start
      t.string :execHost
      t.integer :resourceList_nodect
      t.integer :resourceList_nodes
      t.integer :resourceList.walltime
      t.integer :session
      t.integer :end
      t.integer :exitStatus
      t.integer :resourceUsed_cput
      t.integer :resourceUsed_mem
      t.integer :resourceUsed_vmem
      t.integer :resourceUsed_walltime

      t.timestamps
    end
  end
end

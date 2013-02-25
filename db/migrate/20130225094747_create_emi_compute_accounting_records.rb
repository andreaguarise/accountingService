class CreateEmiComputeAccountingRecords < ActiveRecord::Migration
  def change
    create_table :emi_compute_accounting_records do |t|
      t.string :recordId
      t.timestamp :createTime
      t.string :globalJobId
      t.string :localJobId
      t.string :localUserId
      t.string :globalUserName
      t.integer :charge
      t.string :status
      t.string :queue
      t.string :group
      t.string :jobName
      t.string :ceCertificateSubject
      t.integer :wallDuration
      t.integer :cpuDuration
      t.timestamp :endTime
      t.timestamp :startTime
      t.string :machineName
      t.string :projectName
      t.string :ceHost
      t.string :execHost
      t.integer :physicalMemory
      t.integer :virtualMemory
      t.integer :serviceLevelIntBench
      t.string :serviceLevelIntBenchType
      t.integer :serviceLevelFloatBench
      t.string :serviceLevelFloatBenchType
      t.timestamp :timeInstantCtime
      t.timestamp :timeInstantQTime
      t.timestamp :timeInstantETime
      t.string :dgasAccountingProcedure
      t.string :vomsFQAN
      t.string :execCe
      t.string :lrmsServer
      t.string :voOrigin

      t.timestamps
    end
  end
end

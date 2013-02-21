class CreateDgasGridCpuRecords < ActiveRecord::Migration
  def change
    create_table :dgas_grid_cpu_records do |t|
      t.string :uniqueChecksum
      t.string :dgJobId
      t.timestamp :startDate
      t.timestamp :endDate
      t.integer :resource_id
      t.string :globaluserName
      t.string :FQAN
      t.string :userVO
      t.integer :cpuTime
      t.integer :wallTime
      t.integer :pmem
      t.integeriBench :vmem
      t.string :iBenchType
      t.integer :fBench
      t.string :fBenchType
      t.string :lrmsID
      t.string :local_user
      t.string :local_group
      t.stringaccountingProcedure :urSource
      t.string :voOrigin
      t.string :executingNodes
      t.integer :numNodes

      t.timestamps
    end
  end
end

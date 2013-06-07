# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130607150316) do

  create_table "batch_cpu_summaries", :force => true do |t|
    t.date     "date"
    t.string   "publisher_id"
    t.integer  "totalRecords"
    t.integer  "totalCpuT"
    t.integer  "totalWallT"
    t.string   "localUser"
    t.string   "localGroup"
    t.string   "queue"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "batch_execute_records", :force => true do |t|
    t.string   "uniqueId"
    t.datetime "recordDate"
    t.string   "lrmsId"
    t.string   "user"
    t.string   "group"
    t.string   "jobName"
    t.string   "queue"
    t.integer  "ctime"
    t.integer  "qtime"
    t.integer  "etime"
    t.integer  "start"
    t.string   "execHost"
    t.integer  "resourceList_nodect"
    t.integer  "resourceList_nodes"
    t.integer  "resourceList_walltime"
    t.integer  "session"
    t.integer  "end"
    t.integer  "exitStatus"
    t.integer  "resourceUsed_cput"
    t.integer  "resourceUsed_mem"
    t.integer  "resourceUsed_vmem"
    t.integer  "resourceUsed_walltime"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "publisher_id"
  end

  create_table "benchmark_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "benchmark_values", :force => true do |t|
    t.integer  "benchmark_type_id"
    t.float    "value"
    t.datetime "date"
    t.integer  "publisher_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "blah_records", :force => true do |t|
    t.string   "uniqueId"
    t.datetime "recordDate"
    t.datetime "timestamp"
    t.string   "userDN"
    t.string   "userFQAN"
    t.string   "ceId"
    t.string   "jobId"
    t.string   "lrmsId"
    t.integer  "localUser"
    t.string   "clientId"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "publisher_id"
  end

  create_table "cloud_records", :force => true do |t|
    t.string   "VMUUID"
    t.integer  "resource_id"
    t.string   "localVMID"
    t.string   "local_user"
    t.string   "local_group"
    t.string   "globaluserName"
    t.string   "FQAN"
    t.string   "status"
    t.datetime "startTime"
    t.datetime "endTime"
    t.integer  "suspendDuration"
    t.integer  "wallDuration"
    t.integer  "cpuDuration"
    t.integer  "cpuCount"
    t.string   "networkType"
    t.integer  "networkInbound"
    t.integer  "networkOutBound"
    t.integer  "memory"
    t.integer  "disk"
    t.string   "storageRecordId"
    t.string   "diskImage"
    t.string   "cloudType"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "publisher_id"
  end

  create_table "dgas_grid_cpu_records", :force => true do |t|
    t.string   "uniqueChecksum"
    t.string   "dgJobId"
    t.datetime "startDate"
    t.datetime "endDate"
    t.integer  "resource_id"
    t.string   "globaluserName"
    t.string   "FQAN"
    t.string   "userVO"
    t.integer  "cpuTime"
    t.integer  "wallTime"
    t.integer  "pmem"
    t.integer  "vmem"
    t.integer  "iBench"
    t.string   "iBenchType"
    t.integer  "fBench"
    t.string   "fBenchType"
    t.string   "lrmsID"
    t.string   "local_user"
    t.string   "local_group"
    t.string   "urSource"
    t.string   "accountingProcedure"
    t.string   "voOrigin"
    t.string   "executingNodes"
    t.integer  "numNodes"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "emi_compute_accounting_records", :force => true do |t|
    t.string   "recordId"
    t.datetime "createTime"
    t.string   "globalJobId"
    t.string   "localJobId"
    t.string   "localUserId"
    t.string   "globalUserName"
    t.integer  "charge"
    t.string   "status"
    t.string   "queue"
    t.string   "group"
    t.string   "jobName"
    t.string   "ceCertificateSubject"
    t.integer  "wallDuration"
    t.integer  "cpuDuration"
    t.datetime "endTime"
    t.datetime "startTime"
    t.string   "machineName"
    t.string   "projectName"
    t.string   "ceHost"
    t.string   "execHost"
    t.integer  "physicalMemory"
    t.integer  "virtualMemory"
    t.integer  "serviceLevelIntBench"
    t.string   "serviceLevelIntBenchType"
    t.integer  "serviceLevelFloatBench"
    t.string   "serviceLevelFloatBenchType"
    t.datetime "timeInstantCtime"
    t.datetime "timeInstantQTime"
    t.datetime "timeInstantETime"
    t.string   "dgasAccountingProcedure"
    t.string   "vomsFQAN"
    t.string   "voOrigin"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "publisher_id"
  end

  create_table "emi_storage_records", :force => true do |t|
    t.string   "recordIdentity"
    t.string   "storageSystem"
    t.string   "site"
    t.string   "storageShare"
    t.string   "storageMedia"
    t.string   "storageClass"
    t.integer  "fileCount",                 :limit => 20
    t.string   "directoryPath"
    t.string   "localUser"
    t.string   "localGroup"
    t.string   "userIdentity"
    t.string   "group"
    t.string   "groupAttribute"
    t.string   "attributeType"
    t.datetime "startTime"
    t.datetime "endTime"
    t.integer  "resourceCapacityUsed",      :limit => 20
    t.integer  "logicalCapacityUsed",       :limit => 20
    t.integer  "resourceCapacityAllocated", :limit => 20
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "publisher_id"
  end

  create_table "grid_cpu_records", :force => true do |t|
    t.integer  "batch_execute_record_id"
    t.integer  "blah_record_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "local_cpu_summaries", :force => true do |t|
    t.date     "date"
    t.string   "publisher_id"
    t.integer  "totalRecords"
    t.integer  "totalCpuT"
    t.integer  "totalWallT"
    t.string   "localUser"
    t.string   "localGroup"
    t.string   "queue"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.float    "normalisedCpuT"
    t.float    "normalisedWallT"
  end

  create_table "publishers", :force => true do |t|
    t.string   "hostname"
    t.string   "ip"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "resource_id"
  end

  create_table "resource_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "site_id"
    t.integer  "resource_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "storage_summary_ones", :force => true do |t|
    t.date     "date"
    t.string   "publisher_id"
    t.string   "site"
    t.string   "storageSystem"
    t.integer  "resourceCapacityAllocated", :limit => 8
    t.integer  "resourceCapacityUsed",      :limit => 8
    t.integer  "logicalCapacityUsed",       :limit => 8
    t.integer  "storageClass"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "role_id"
  end

end

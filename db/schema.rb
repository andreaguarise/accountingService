# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20141017064129) do

  create_table "apel_ssm_records", :force => true do |t|
    t.integer  "publisher_id"
    t.datetime "recordDate"
    t.string   "submitHost"
    t.string   "machineName"
    t.string   "queue"
    t.string   "localJobId"
    t.string   "localUserId"
    t.string   "globalUserName"
    t.string   "fqan"
    t.string   "vo"
    t.string   "voGroup"
    t.string   "voRole"
    t.integer  "wallDuration"
    t.integer  "cpuDuration"
    t.string   "processors"
    t.integer  "nodeCount"
    t.integer  "startTime"
    t.integer  "endTime"
    t.string   "infrastructureDescription"
    t.string   "infrastructureType"
    t.integer  "memoryReal"
    t.integer  "memoryVirtual"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "apel_ssm_records", ["localJobId", "recordDate"], :name => "unique_index", :unique => true
  add_index "apel_ssm_records", ["publisher_id"], :name => "index_apel_ssm_records_on_publisher_id"
  add_index "apel_ssm_records", ["recordDate"], :name => "index_apel_ssm_records_on_recordDate"
  add_index "apel_ssm_records", ["vo"], :name => "index_apel_ssm_records_on_vo"

  create_table "batch_execute_records", :force => true do |t|
    t.string   "uniqueId"
    t.datetime "recordDate"
    t.string   "lrmsId"
    t.string   "localUser"
    t.string   "localGroup"
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

  add_index "batch_execute_records", ["lrmsId"], :name => "index_batch_execute_records_on_lrmsId"
  add_index "batch_execute_records", ["publisher_id"], :name => "batch_execute_records_publisher_id"
  add_index "batch_execute_records", ["publisher_id"], :name => "index_batch_execute_records_on_publisher_id"
  add_index "batch_execute_records", ["recordDate"], :name => "index_batch_execute_records_on_recordDate"
  add_index "batch_execute_records", ["uniqueId"], :name => "index_batch_execute_records_on_uniqueId", :unique => true

  create_table "benchmark_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "benchmark_values", :force => true do |t|
    t.integer  "benchmark_type_id"
    t.float    "value"
    t.date     "date"
    t.integer  "publisher_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "benchmark_values", ["date"], :name => "date"
  add_index "benchmark_values", ["publisher_id"], :name => "publisher_id"

  create_table "cloud_record_summaries", :id => false, :force => true do |t|
    t.integer "id",                                                           :default => 0, :null => false
    t.string  "date",            :limit => 24
    t.integer "site_id"
    t.string  "local_group"
    t.string  "local_user"
    t.string  "status"
    t.integer "vmCount",         :limit => 8,                                 :default => 0, :null => false
    t.decimal "wallDuration",                  :precision => 36, :scale => 4
    t.decimal "cpuDuration",                   :precision => 36, :scale => 4
    t.decimal "networkInbound",                :precision => 45, :scale => 4
    t.decimal "networkOutbound",               :precision => 45, :scale => 4
    t.decimal "cpuCount",                      :precision => 34, :scale => 6
    t.decimal "disk",                          :precision => 36, :scale => 4
    t.decimal "memory",                        :precision => 36, :scale => 4
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
    t.decimal  "cpuCount",                         :precision => 8, :scale => 2
    t.string   "networkType"
    t.integer  "networkInbound",      :limit => 8
    t.integer  "networkOutBound",     :limit => 8
    t.integer  "memory"
    t.integer  "disk"
    t.string   "storageRecordId"
    t.string   "diskImage"
    t.string   "cloudType"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "publisher_id"
    t.string   "hypervisor_hostname"
  end

  add_index "cloud_records", ["publisher_id"], :name => "index_cloud_records_on_publisher_id"

  create_table "cloud_view_vm_summaries", :id => false, :force => true do |t|
    t.integer  "id",                                             :default => 0, :null => false
    t.datetime "date"
    t.string   "VMUUID"
    t.string   "localVMID"
    t.integer  "publisher_id"
    t.string   "local_user"
    t.string   "local_group"
    t.string   "status"
    t.string   "diskImage"
    t.string   "cloudType"
    t.decimal  "disk",            :precision => 14, :scale => 4
    t.decimal  "wallDuration",    :precision => 14, :scale => 4
    t.decimal  "cpuDuration",     :precision => 14, :scale => 4
    t.decimal  "networkInbound",  :precision => 23, :scale => 4
    t.decimal  "networkOutbound", :precision => 23, :scale => 4
    t.decimal  "memory",          :precision => 14, :scale => 4
    t.decimal  "cpuCount",        :precision => 12, :scale => 6
  end

  create_table "cpu_grid_norm_records", :id => false, :force => true do |t|
    t.integer  "id",                        :default => 0, :null => false
    t.integer  "publisher_id"
    t.datetime "recordDate"
    t.string   "submitHost"
    t.string   "machineName"
    t.string   "queue"
    t.string   "localJobId"
    t.string   "localUserId"
    t.string   "globalUserName"
    t.string   "fqan"
    t.string   "vo"
    t.string   "voGroup"
    t.string   "voRole"
    t.integer  "wallDuration"
    t.integer  "cpuDuration"
    t.string   "processors"
    t.integer  "nodeCount"
    t.integer  "startTime"
    t.integer  "endTime"
    t.string   "infrastructureDescription"
    t.string   "infrastructureType"
    t.integer  "memoryReal"
    t.integer  "memoryVirtual"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "benchmark_value_id",        :default => 0
  end

  create_table "cpu_grid_summaries", :id => false, :force => true do |t|
    t.integer "id",                                                            :default => 0, :null => false
    t.date    "date"
    t.integer "publisher_id"
    t.string  "globalUserName"
    t.string  "vo"
    t.string  "fqan"
    t.integer "records",           :limit => 8,                                :default => 0, :null => false
    t.decimal "cpuDuration",                    :precision => 32, :scale => 0
    t.decimal "wallDuration",                   :precision => 32, :scale => 0
    t.float   "benchmark_value"
    t.integer "benchmark_type_id"
  end

  create_table "database_descrs", :force => true do |t|
    t.string   "backend"
    t.string   "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "database_record_summaries", :id => false, :force => true do |t|
    t.integer "id",                                               :default => 0, :null => false
    t.date    "record_date"
    t.string  "table_name"
    t.string  "scheme_name"
    t.decimal "rows",              :precision => 23, :scale => 4
    t.decimal "tablesize",         :precision => 23, :scale => 4
    t.decimal "indexsize",         :precision => 23, :scale => 4
    t.integer "publisher_id"
    t.integer "database_descr_id"
  end

  create_table "database_record_summaries_ls", :id => false, :force => true do |t|
    t.integer "id",                                                            :default => 0, :null => false
    t.date    "record_date"
    t.integer "record_timestamp",  :limit => 8
    t.string  "table_name"
    t.string  "scheme_name"
    t.integer "rows",              :limit => 8
    t.decimal "tablesize",                      :precision => 23, :scale => 4
    t.decimal "indexsize",                      :precision => 23, :scale => 4
    t.integer "publisher_id"
    t.integer "database_descr_id"
  end

  create_table "database_records", :force => true do |t|
    t.datetime "time"
    t.integer  "rows",              :limit => 8
    t.integer  "tablesize",         :limit => 8
    t.integer  "indexsize",         :limit => 8
    t.integer  "database_table_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "database_schemes", :force => true do |t|
    t.string   "name"
    t.integer  "publisher_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "database_descr_id"
  end

  create_table "database_tables", :force => true do |t|
    t.string   "name"
    t.integer  "database_scheme_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "emi_storage_records", :force => true do |t|
    t.string   "recordIdentity"
    t.string   "storageSystem"
    t.string   "site"
    t.string   "storageShare"
    t.string   "storageMedia"
    t.string   "storageClass"
    t.integer  "fileCount",                 :limit => 8
    t.string   "directoryPath"
    t.string   "localUser"
    t.string   "localGroup"
    t.string   "userIdentity"
    t.string   "group"
    t.string   "groupAttribute"
    t.string   "attributeType"
    t.datetime "startTime"
    t.datetime "endTime"
    t.integer  "resourceCapacityUsed",      :limit => 8
    t.integer  "logicalCapacityUsed",       :limit => 8
    t.integer  "resourceCapacityAllocated", :limit => 8
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "publisher_id"
  end

  add_index "emi_storage_records", ["publisher_id"], :name => "index_emi_storage_records_on_publisher_id"

  create_table "grid_pledges", :force => true do |t|
    t.integer  "site_id"
    t.date     "validFrom"
    t.date     "validTo"
    t.integer  "value"
    t.integer  "logicalCPU"
    t.integer  "physicalCPU"
    t.integer  "benchmark_type_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
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

  add_index "publishers", ["resource_id"], :name => "resource_id"

  create_table "resource_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "site_id"
    t.integer  "resource_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "resources", ["resource_type_id"], :name => "resource_type_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "since_table_prooftaf", :id => false, :force => true do |t|
    t.string  "table"
    t.integer "place"
  end

  create_table "since_table_root", :id => false, :force => true do |t|
    t.string  "table"
    t.integer "place"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "storage_summaries", :force => true do |t|
    t.date     "date"
    t.string   "publisher_id"
    t.string   "site"
    t.string   "storageSystem"
    t.string   "group"
    t.integer  "resourceCapacityUsed",      :limit => 8
    t.integer  "logicalCapacityUsed",       :limit => 8
    t.string   "storageShare"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "resourceCapacityAllocated", :limit => 8
  end

  create_table "storage_summaries_view", :id => false, :force => true do |t|
    t.date     "date"
    t.integer  "publisher_id"
    t.string   "site"
    t.string   "storageSystem"
    t.string   "group"
    t.integer  "resourceCapacityUsed",      :limit => 8
    t.integer  "resourceCapacityAllocated", :limit => 8
    t.integer  "logicalCapacityUsed",       :limit => 8
    t.string   "storageShare"
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

##WARNING  This model has no rea underlying table. Ineriths from LocaCpuRecord. It's purpose is just to show batch record
##considered to be local becous no grid information are available.

class LocalCpuRecord < BatchExecuteRecord
  def self.all
    BatchExecuteRecord.find_by_sql("SELECT \"batch_execute_records\".* FROM batch_execute_records LEFT JOIN grid_cpu_records ON grid_cpu_records.batch_execute_record_id=batch_execute_records.id WHERE grid_cpu_records.id IS NULL")
  end

end


##WARNING  This model has no rea underlying table. Ineriths from LocaCpuRecord. It's purpose is just to show batch record
##considered to be local becous no grid information are available.

class LocalCpuRecord < BatchExecuteRecord
  default_scope joins("LEFT JOIN grid_cpu_records ON  grid_cpu_records.batch_execute_record_id=batch_execute_records.id").where("grid_cpu_records.id IS NULL")
  #default scope apply to all methods:
  #
  #  BatchExecuteRecord.find_by_sql("SELECT batch_execute_records.* FROM batch_execute_records LEFT JOIN grid_cpu_records ON grid_cpu_records.batch_execute_record_id=batch_execute_records.id WHERE grid_cpu_records.id IS NULL")
  #  which is like:
  #  BatchExecuteRecord.joins("LEFT JOIN grid_cpu_records ON  grid_cpu_records.batch_execute_record_id=batch_execute_records.id").where("grid_cpu_records.id IS NULL")  
  # 
  
  def self.summary(startDate = "")
    dateQuery =""
    if ( Rails.env.production? )
      dateQuery = "date(FROM_UNIXTIME(end))"#MYSQL syntax
    else
      dateQuery = "date(end,'unixepoch', 'localtime')"#sqlite syntax
    end   
    summary = LocalCpuRecord.select("#{dateQuery} as eDate,publisher_id,queue,\"group\" as unixGroup,user as unixUser,count(lrmsId) as countRecord,sum(resourceUsed_cput)as sumCpu,sum(resourceUsed_walltime) as sumWall" ).group(:eDate,:publisher_id,:queue,:unixUser, :unixGroup)
    if startDate != ""
      summary = summary.where(" recordDate >= #{startDate}")
    end
    summary  
  end

end


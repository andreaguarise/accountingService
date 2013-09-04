##WARNING  This model has no real underlying table. Inherits from LocaCpuRecord. It's purpose is just to show batch record
##considered to be local since no related grid information are available.

class LocalCpuRecord < BatchExecuteRecord
  #default_scope includes(:publisher).joins("LEFT JOIN grid_cpu_records ON grid_cpu_records.batch_execute_record_id=batch_execute_records.id").where("grid_cpu_records.id IS NULL")
  default_scope includes(:publisher).joins("LEFT JOIN blah_records ON blah_records.lrmsId=batch_execute_records.lrmsId").where("blah_records.id IS NULL")
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
    summary = LocalCpuRecord.select("#{dateQuery} as eDate,batch_execute_records.publisher_id,queue,localGroup as localGroup,batch_execute_records.localUser as localUser,count(batch_execute_records.lrmsId) as countRecord,sum(resourceUsed_cput)as sumCpu,sum(resourceUsed_walltime) as sumWall" ).group(:eDate,"batch_execute_records.publisher_id",:queue,:localUser,:localGroup)
    if startDate != ""
      summary = summary.where(" batch_execute_record.recordDate >= #{startDate}")
    end
    summary  
  end

end


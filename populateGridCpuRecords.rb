BlahRecord.find_each(:batch_size => 10) { |b|
  t = BatchExecuteRecord.where("lrmsId=? AND recordDate > ?",b.lrmsId,b.recordDate)
  if t[0]
    g= GridCpuRecord.new()
    g.blah_record_id = b.id
    g.batch_execute_record_id = t[0].id
    g.save
  end
}

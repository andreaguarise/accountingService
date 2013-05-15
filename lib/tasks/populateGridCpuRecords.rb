BlahRecord.find_each(:batch_size => 50) { |b|
  t = TorqueExecuteRecord.where("lrmsId=? AND recordDate >= ?",b.lrmsId,b.recordDate)
  if t[0]
    g= GridCpuRecord.new()
    g.blah_record_id = b.id
    g.recordlike_id = t[0].id
    g.recordlike_type = "TorqueExecuteRecord"
    g.save
  end
}

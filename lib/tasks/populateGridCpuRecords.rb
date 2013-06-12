lastInsertedGridRecord = GridCpuRecord.last
lastInsertedBlahRecordId = 0
if lastInsertedGridRecord
  lastInsertedBlahRecordId = lastInsertedGridRecord.blah_record_id 
end

BlahRecord.find_in_batches(:batch_size => 400, :start => lastInsertedBlahRecordId ) { |batch|
    GridCpuRecord.transaction do
      batch.each do |b|
      t = BatchExecuteRecord.select(:id).where("lrmsId=? AND recordDate >= ?",b.lrmsId,b.recordDate)
      if t[0]
        g = GridCpuRecord.create(:blah_record_id => b.id, :batch_execute_record_id => t[0].id)
        g.save
      end
    end
  end
}

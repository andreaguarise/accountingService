partial = {}
running = {}
incremental = 0

started_ary = CloudRecord.group('date(startTime)').count
ended_ary = CloudRecord.group('date(endTime)').count

started_ary.each do |date,startedCount|
if ended_ary[date]
partial[date] = startedCount-ended_ary[date]
else
partial[date] = startedCount
end
incremental = incremental + partial[date]
running[date] = incremental
puts "date:#{date}, running:#{running[date]}  --->  partial: #{partial[date]}"
end

 r = CloudRecord.new
 r.VMUUID = rand.to_s
 r.publisher_id=8
 r.startTime="1361282730"
 r.endTime="2007-04-06 03:21:00"
 r.save
 puts r.to_json

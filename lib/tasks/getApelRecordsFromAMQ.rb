
class BlahRecordConverter
  @@record_ary = Array.new
  @@publishersCache = Hash.new
  @@recordCount = 0
  def initialize (n)
    @n = n
  end
  
  def self.record_ary
    @@record_ary
  end
  
  def self.recordCount
    @@recordCount
  end
  
  def import
    #puts @@record_ary.to_json
    puts @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    puts "#{now} - Blah Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |b|
      b.computeUniqueId
      #puts b.uniqueId
      valuesBuffer << "(NULL,'#{b.uniqueId}','#{b.recordDate}','#{b.recordDate}','#{b.userDN}','#{b.userFQAN}','#{b.ceId}','','#{b.lrmsId}','#{b.localUser}','','#{now}','#{now}',#{b.publisher_id})"
      if b != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "INSERT INTO blah_records (`id`,
`uniqueId`,
`recordDate`,
`timestamp`,
`userDN`,
`userFQAN`,
`ceId`,
`jobId`,
`lrmsId`,
`localUser`,
`clientId`,
`created_at`,
`updated_at`,
`publisher_id`) VALUES "
    bulkInsert << valuesBuffer
    ActiveRecord::Base.connection.execute bulkInsert
    @@record_ary.clear
  end
  
  def convert(r)
    return if r["InfrastructureType"] == "local" # Do not pollute blah_records with non grid jobs.
    if not @@publishersCache.key?(r["MachineName"])
      publisher = Publisher.find_by_hostname(r["MachineName"])
      @@publishersCache[r["MachineName"]] = publisher.id
    end
    if @@publishersCache[r["MachineName"]]
      b = BlahRecord.new
      b.publisher_id = @@publishersCache[r["MachineName"]]
      b.ceId = r["SubmitHost"]
      #b.clientId =
      #b.jobId = r[""]
      b.localUser = r["LocalUserId"] #BLAH has the numericId, APEL the local User Name. This probably should be removed from the table and the MODEL.
      b.lrmsId = r["LocalJobId"]
      b.recordDate = Time.at(r["StartTime"].to_i).strftime("%Y-%m-%d %H:%M:%S") #BLAH do lag at the start of the job
      b.timestamp = r["StartTime"]
      #b.uniqueId = ##AUTOMATICALLY INSERTED BY SERVER in MODEL
      b.userDN = r["GlobalUserName"]
      b.userFQAN = r["FQAN"]
      @@record_ary << b
      @@recordCount = @@recordCount + 1;
      #puts @@record_ary.length
      if ( @@record_ary.length >= @n )
        self.import
      end
      #puts "RecordDate --> **#{b.recordDate.to_s}**"
      #puts "publisher_id --> #{b.publisher_id}"
    end
    #puts "MachineName --> **#{r["MachineName"]}**"
    
  end
  
  
end

class EventRecordConverter
  @@record_ary = Array.new
  @@publishersCache = Hash.new
  @@recordCount = 0
  def initialize (n)
    @n = n
  end
  
  def import
    puts @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    puts "#{now} - Event Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |e|
      e.computeUniqueId
      #puts b.uniqueId
      valuesBuffer << "(NULL,'#{e.uniqueId}','#{e.recordDate}','#{e.lrmsId}','#{e.localUser}','','','#{e.queue}','','','',#{e.start},'#{e.execHost}',#{e.resourceList_nodect},'','','',#{e.end},'',#{e.resourceUsed_cput},#{e.resourceUsed_mem},#{e.resourceUsed_vmem},#{e.resourceUsed_walltime},'#{now}','#{now}',#{e.publisher_id})"
      if e != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "INSERT INTO batch_execute_records
(`id`,
`uniqueId`,
`recordDate`,
`lrmsId`,
`localUser`,
`localGroup`,
`jobName`,
`queue`,
`ctime`,
`qtime`,
`etime`,
`start`,
`execHost`,
`resourceList_nodect`,
`resourceList_nodes`,
`resourceList_walltime`,
`session`,
`end`,
`exitStatus`,
`resourceUsed_cput`,
`resourceUsed_mem`,
`resourceUsed_vmem`,
`resourceUsed_walltime`,
`created_at`,
`updated_at`,
`publisher_id`)
VALUES "
    bulkInsert << valuesBuffer
    ActiveRecord::Base.connection.execute bulkInsert
    @@record_ary.clear
  end
  
  def convert(r)
    if not @@publishersCache.key?(r["MachineName"])
      publisher = Publisher.find_by_hostname(r["MachineName"])
      @@publishersCache[r["MachineName"]] = publisher.id
    end
    if @@publishersCache[r["MachineName"]]
      e = BatchExecuteRecord.new
      #e.ctime =
      e.end = r["EndTime"]
      #e.etime =
      e.execHost = r["MachineName"]
      #e.exitStatus =
      #e.localGroup = 
      #e.jobName =
      e.lrmsId = r["LocalJobId"]
      e.publisher_id = @@publishersCache[r["MachineName"]]
      #e.qtime =
      e.queue = r["Queue"]
      e.recordDate = Time.at(r["EndTime"].to_i).strftime("%Y-%m-%d %H:%M:%S") #LRMS do lag at the end of the job
      #e.resourceList_walltime = 
      e.resourceList_nodect = r["Processors"]
      #e.resourceList_nodes =
      e.resourceUsed_cput = r["CpuDuration"] #seconds
      e.resourceUsed_mem = r["MemoryReal"] #KBytes
      e.resourceUsed_vmem = r["MemoryVirtual"] #Kbytes
      e.resourceUsed_walltime = r["WallDuration"] #seconds
      #e.session =
      e.start = r["StartTime"]
      #e.uniqueId = "" #AUTOMATICALLY INSERTED BY SERVER in MODEL
      e.localUser = r["LocalUserId"]
      e.recordDate = Time.at(r["StartTime"].to_i).strftime("%Y-%m-%d %H:%M:%S")
    
      @@record_ary << e
      @@recordCount = @@recordCount + 1;
      if ( @@record_ary.length >= @n )
        self.import
      end
    end
  end
end

class SSMMessage
  def initialize(m)
    @m = m
    @records = Array.new
  end
  
  def to_s
    @m.to_s
  end
  
  def parse
    recordBuff = Hash.new
    haveApelRecord =false
    @m.lines.each do |line|
      if ( line =~ /%%/ )
        if haveApelRecord
          @records << recordBuff.clone
          recordBuff.clear
        end
        next
      end
      if ( line =~ /^(\w+):\s(.*)$/ )
        recordBuff[$1] = $2.chomp
        haveApelRecord = true;
      end
    end
    @records
  end
  
end

@conn = Stomp::Connection.open '', '', 'dgas-broker.to.infn.it', 61613, false
@count = 0

@conn.subscribe "/queue/apel.output.1"
while @count < 100
  records = Array.new
  @msg = @conn.receive
  @count = @count + 1
  if @msg.command == "MESSAGE"
    ssm_msg = SSMMessage.new(@msg.body)
    records = ssm_msg.parse
    blah = BlahRecordConverter.new(200)
    event = EventRecordConverter.new(200)
    records.each do |r|
        if records.length >= 200
          #treat case when there are at least n records to be bulk processed
          event.convert(r)
          blah.convert(r)
        else
          puts "#{records.length} remaining in message --> Single insert."
          #treat case where there are no sufficient record to be bulk processed
          partialEvent = EventRecordConverter.new(records.length) if not partialEvent
          partialEvent.convert(r)
          partialBlah = BlahRecordConverter.new(records.length) if not partialBlah
          partialBlah.convert(r)
        end
    end
  end
end
@conn.disconnect







require 'optparse'
require 'timeout'

class DirQ  
  def initialize(parent)
    @parent=parent
  end
  
  def dir
    dir = "deadbeef"
    if (!File.directory? "#{@parent}/#{dir}")
      Dir.mkdir "#{@parent}/#{dir}"
    end
    dir
  end
  
  def RandomExa(length, chars = 'abcdef0123456789')
        rnd_str = ''
        length.times { rnd_str << chars[rand(chars.size)] }
        rnd_str
  end
  
  def file
    time = Time.now.to_i
    timeHex = time.to_s(16)
    random_string = self.RandomExa(6)
    filename = timeHex + random_string
    filename
  end
  
end

class DeadMessage
  def initialize(message,parent_dir)
    @message = message
    @parent_dir = parent_dir
    @dirq = DirQ.new(parent_dir)
    @filename = @dirq.dir + "/" + @dirq.file    
  end 
  
  def write
    open("#{@parent_dir}/#{@filename}", "a") { |f| f << @message }
  end
end

class BenchmarkRecordConverter
  ## use to populate benchmark values (the model server side already takes care of the sampling period)
  @@publishersCache = Hash.new
  @@lastBenchmark = Hash.new
  
  def convert(r)
    if not @@publishersCache.key?(r["MachineName"])
      publisher = Publisher.find_by_hostname(r["MachineName"])
      @@publishersCache[r["MachineName"]] = publisher.id
    end
    if @@publishersCache[r["MachineName"]]
      
      bv = BenchmarkValue.new
      bv.publisher_id = @@publishersCache[r["MachineName"]] 
      bv.date = Time.at(r["EndTime"].to_i).strftime("%Y-%m-%d %H:%M:%S")
      bv.value = r["ServiceLevel"]
      #LOG HERE FOR DEBUG
      if not @@lastBenchmark.key?(r["MachineName"])
        @@lastBenchmark[r["MachineName"]] = "0"
        #puts "lastBenchmark inserting #{r["MachineName"]} --> #{@@lastBenchmark[r["MachineName"]]}"
      end
      #puts "lastBenchmark:#{r["MachineName"]} --> #{r["EndTime"]} -- #{@@lastBenchmark[r["MachineName"]]}"
      if r["EndTime"].to_i - @@lastBenchmark[r["MachineName"]].to_i > 86400
        bt = BenchmarkType.new
        ##GO on by creating ActiveRecord benchmarkvalue object and saving it.
        if (r["ServiceLevelType"] == "si2k" )
            bt = BenchmarkType.find_by_name("specInt2k")
        end
        if (r["ServiceLevelType"] == "hs06" )##check against apel
            bt = BenchmarkType.find_by_name("HEPSPEC06")
        end
        bv.benchmark_type_id = bt.id
        bv.save
        @@lastBenchmark[r["MachineName"]] = r["EndTime"]
      end
    end
  end
end

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
    #Rails.logger.info @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    Rails.logger.info "#{now} - Blah Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |b|
      b.computeUniqueId
      valuesBuffer << "(NULL,'#{b.uniqueId}','#{b.recordDate}','#{b.recordDate}','#{b.userDN}','#{b.userFQAN}','#{b.ceId}','','#{b.lrmsId}','#{b.localUser}','','#{now}','#{now}',#{b.publisher_id})"
      if b != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "INSERT IGNORE INTO blah_records (`id`,
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
    if ! @@publishersCache[r["MachineName"]]
      #Publisher does not exists.
      site = Site.find_by_name(r["Site"])
      rtype = ResourceType.find_by_name("Farm_grid+local") 
      autoResource = Resource.new
      autoResource.resource_type_id = rtype.id
      autoResource.name = "#{r["Site"]}-autoCE"
      Rails.logger.info "Creating Resource: #{autoResource.name}"
      autoResource.site_id = site.id
      autoResource.save
      autoResource.find_by_name(autoResource.name)
      autoPublisher = Publisher.new
      autoPublisher.hostname = r["MachineName"]
      Rails.logger.info "Creating Publisher: #{autoPublisher.hostname}"
      autoPublisher.resource_id = autoResource.id
      autoPublisher.save
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
      b.recordDate = Time.at(r["StartTime"].to_i).strftime("%Y-%m-%d %H:%M:%S") #BLAH do log at the start of the job
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
    #puts @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    Rails.logger.info "#{now} - Event Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |e|
      Rails.logger.debug "#{now} date:#{e.recordDate} lrmsId:#{e.lrmsId}"
      if ( ! e.recordDate ) || ( ! e.lrmsId )
        Rails.logger.info "#{now} #{e.to_json}"
      end
      e.computeUniqueId
      valuesBuffer << "(NULL,'#{e.uniqueId}','#{e.recordDate}','#{e.lrmsId}','#{e.localUser}','','','#{e.queue}','','','',#{e.start},'#{e.execHost}',#{e.resourceList_nodect},'','','',#{e.end},'',#{e.resourceUsed_cput},#{e.resourceUsed_mem},#{e.resourceUsed_vmem},#{e.resourceUsed_walltime},'#{now}','#{now}',#{e.publisher_id})"
      if e != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "INSERT IGNORE INTO batch_execute_records
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
    if not r["MachineName"]
      Rails.logger.info "#{r.to_json}"
    end
    if not @@publishersCache.key?(r["MachineName"])
      publisher = Publisher.find_by_hostname(r["MachineName"])
      if !publisher
        #Publisher does not exists.
        site = Site.find_by_name(r["Site"])
        rtype = ResourceType.find_by_name("Farm_grid+local") 
        autoResource = Resource.new
        autoResource.resource_type_id = rtype.id
        autoResource.name = "#{r["Site"]}-autoCE"
        Rails.logger.info "Creating Resource: #{autoResource.name}"
        autoResource.site_id = site.id
        autoResource.save
        autoPublisher = Publisher.new
        autoPublisher.hostname = r["MachineName"]
        Rails.logger.info "Creating Publisher: #{autoPublisher.hostname}"
        autoPublisher.resource_id = autoResource.id
        autoPublisher.ip = "127.0.0.1"
        autoPublisher.save
        publisher = Publisher.find_by_hostname(r["MachineName"])
        @@publishersCache[r["MachineName"]] = publisher.id
      end
      ##If publisher does not exists create it
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
    else
      puts "Publisher does not exists. Error!"
      exit 1
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
      if ( line =~ /APEL-sync-message/)
        Rails.logger.info "Found APEL sync message. skipping"
        return
      end
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





class ApelSSMRecords
  def initialize
    @options = {}
  end
  
  def getLineParameters
    
    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: opennebulaSensorMain.rb [OPTIONS]"

      @options[:verbose] = false
      opt.on( '-v', '--verbose', 'Output more information') do
        @options[:verbose] = true
      end
      
      @options[:autocreate] = false
      opt.on( '-a', '--autocreate', 'Automatically create publisher and resource (site MUST already exists)') do
        @options[:autocreate] = true
      end
  
      #@options[:dryrun] = false
      #  opt.on( '-d', '--dryrun', 'Do not talk to server') do
      #  @options[:dryrun] = true
      #end
      
      @options[:env] = nil
      opt.on( '-e', '--environment env', 'rails environment') do |env|
        @options[:env] = env
      end
      
      @options[:limit] = 1000
      opt.on( '-L', '--Limit limit', 'number of messages to fetch') do |limit|
        @options[:limit] = limit.to_i
      end
      
      @options[:timeout] = 30
      opt.on( '-T', '--Timeout timeout', 'Timeout to wait for new messages before unsubscribing') do |timeout|
        @options[:timeout] = timeout.to_i
      end
      
      @options[:queue] = nil
      opt.on( '-Q', '--Queue queue', 'JMS Queue to poll') do |queue|
        @options[:queue] = queue  
      end
      
      @options[:bulk] = 100
      opt.on( '-B', '--Bulk bulk', 'number of record insert per single insert command') do |bulk|
        @options[:bulk] = bulk.to_i  
      end
      
      @options[:uri] = nil
      opt.on( '-U', '--Uri uri', 'Broker uri e.g. dgas.broker.to.infn.it:61613') do |uri|
        @options[:uri] = uri
      end
      
      @options[:deaddir] = nil
      opt.on( '-D', '--Deaddir path', 'Path to directory used as dead letter repository, for apel SSM to resend it to queue') do |dir|
        @options[:deaddir] = dir
      end

      opt.on( '-h', '--help', 'Print this screen') do
        puts opt
        exit
      end 
    end

    opt_parser.parse!
  end
  
  def main
    self.getLineParameters
    Rails.logger.info "Retrieving SSM grid records messages from queue: #{@options[:queue]}"
    pattern = /^(.*):(.*)$/
    pattern =~ @options[:uri]
    data = Regexp.last_match
    host = data[1]
    port = data[2]
    Rails.logger.info "Broker: #{host}, port: #{port}"
    @conn = Stomp::Connection.open '', '', host, port, false
    @count = 0

    @conn.subscribe "/queue/#{@options[:queue]}"
    while @count < @options[:limit]
      records = Array.new
      begin Timeout::Error
      timeout(@options[:timeout]) { @msg = @conn.receive }
      rescue Timeout::Error
        @conn.unsubscribe "/queue/#{@options[:queue]}"
        @conn.disconnect
        Rails.logger.info "No more messages. Exiting."
        return
      end
      @count = @count + 1
      if @msg.command == "MESSAGE"
        ssm_msg = SSMMessage.new(@msg.body)
        Rails.logger.debug "#{ssm_msg}"
        begin
          records = ssm_msg.parse
          next if not records
          blah = BlahRecordConverter.new(@options[:bulk])
          event = EventRecordConverter.new(@options[:bulk])
          benchmark = BenchmarkRecordConverter.new
          records.each do |r|
            if records.length >= @options[:bulk]
               #treat case when there are at least n records to be bulk processed
                event.convert(r)
                blah.convert(r)
                benchmark.convert(r)
           else
                Rails.logger.info "#{records.length} remaining in message --> Single insert."
                #treat case where there are no sufficient record to be bulk processed
                partialEvent = EventRecordConverter.new(records.length) if not partialEvent
                Rails.logger.debug "Do single Event"
                partialEvent.convert(r)
                partialBlah = BlahRecordConverter.new(records.length) if not partialBlah
                Rails.logger.debug "Do single Blah"
               partialBlah.convert(r)
                benchmark.convert(r) #we do not do bulk insert for benchmarks
            end
          end
        rescue Exception => e
           Rails.logger.info "Got Error inserting records, pushing message to dead.letter.queue"
           Rails.logger.info "Error: #{e.message}"
           Rails.logger.info e.backtrace.inspect
           dm = DeadMessage.new(@msg.body,@options[:deaddir])
           dm.write
        end  
      end
    end
    @conn.unsubscribe "/queue/#{@options[:queue]}"
    @conn.disconnect
  end
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

SSM = ApelSSMRecords.new
SSM.main





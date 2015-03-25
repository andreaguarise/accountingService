require 'optparse'
require 'timeout'

class Logger
  def initialize
    
  end
  
  def self.log(msg)
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    Rails.logger.info "#{now}: #{msg}"
  end
end

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
  @@sitesCache = Hash.new
  @@lastBenchmark = Hash.new
  
  def convert(r)
    if not @@sitesCache.key?(r["Site"])
      site = Site.find_by_name(r["Site"])#FIXME Implement a cache for this, it slows down the insert
      if !site
        Logger.log "#{r["Site"]}: Does not exists!"
        raise "Site #{r["Site"]} does not exists."
      end
      @@sitesCache[r["Site"]] = site.id
    end
    if not @@publishersCache.key?("#{r["Site"]}.#{r["MachineName"]}")
      publisher = Publisher.includes(:resource).where('resources.site_id' => @@sitesCache[r["Site"]]).find_by_hostname(r["MachineName"])
      @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"] = publisher.id
    end
    if @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"]
      
      bv = BenchmarkValue.new
      bv.publisher_id = @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"] 
      bv.date = Time.at(r["EndTime"].to_i).strftime("%Y-%m-%d %H:%M:%S")
      bv.value = r["ServiceLevel"]
      #LOG HERE FOR DEBUG
      if not @@lastBenchmark.key?(r["MachineName"])
        @@lastBenchmark[r["MachineName"]] = "0"
        #puts "lastBenchmark inserting #{r["MachineName"]} --> #{@@lastBenchmark[r["MachineName"]]}"
      end
      #puts "lastBenchmark:#{r["MachineName"]} --> #{r["EndTime"]} -- #{@@lastBenchmark[r["MachineName"]]}"
      if r["EndTime"].to_i - @@lastBenchmark[r["MachineName"]].to_i > 3600
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


class ApelSsmRecordConverter
  @@record_ary = Array.new
  @@publishersCache = Hash.new
  @@sitesCache = Hash.new
  @@recordCount = 0
  def initialize (n)
    @n = n
  end
  
  def import
    #puts @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    Logger.log "#{now}- Apel SSM Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |e|
      Rails.logger.debug "#{now} date:#{e.recordDate} lrmsId:#{e.localJobId}"
      if ( ! e.recordDate ) || ( ! e.localJobId )
        Logger.log "#{now} #{e.to_json}"
      end
      valuesBuffer << "(NULL,#{e.publisher_id},'#{e.recordDate}','#{e.submitHost}','#{e.machineName}','#{e.queue}','#{e.localJobId}','#{e.localUserId}','#{e.globalUserName}','#{e.fqan}','#{e.vo}','#{e.voGroup}','#{e.voRole}',#{e.wallDuration},#{e.cpuDuration},#{e.processors},#{e.nodeCount},#{e.startTime},#{e.endTime},'#{e.infrastructureDescription}','#{e.infrastructureType}',#{e.memoryReal},#{e.memoryVirtual},'#{now}','#{now}')"
      if e != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "REPLACE INTO apel_ssm_records
(`id`,
`publisher_id`,
`recordDate`,
`submitHost`,
`machineName`,
`queue`,
`localJobId`,
`localUserId`,
`globalUserName`,
`fqan`,
`vo`,
`voGroup`,
`voRole`,
`wallDuration`,
`cpuDuration`,
`processors`,
`nodeCount`,
`startTime`,
`endTime`,
`infrastructureDescription`,
`infrastructureType`,#
`memoryReal`,
`memoryVirtual`,
`created_at`,
`updated_at`
)
VALUES "
    bulkInsert << valuesBuffer
    ActiveRecord::Base.connection.execute bulkInsert
    @@record_ary.clear
  end
  
  def convert(r)
    if not r["MachineName"]
      Logger.log "#{r.to_json}"
    end
    if not @@sitesCache.key?(r["Site"])
      site = Site.find_by_name(r["Site"])#FIXME Implement a cache for this, it slows down the insert
      if !site
        Rails.logger.info "#{r["Site"]}: Does not exists!"
        raise "Site #{r["Site"]} does not exists."
      end
      @@sitesCache[r["Site"]] = site.id
    end
    if not @@publishersCache.key?("#{r["Site"]}.#{r["MachineName"]}")
      publisher = Publisher.includes(:resource).where('resources.site_id' => @@sitesCache[r["Site"]]).find_by_hostname(r["MachineName"])
      if !publisher
        #Publisher does not exists.
        rtype = ResourceType.find_by_name("Farm_grid+local") 
        autoResource = Resource.new
        autoResource.resource_type_id = rtype.id
        autoResource.name = "#{r["Site"]}-autoCE"
        autoResource = Resource.find_by_name("#{r["Site"]}-autoCE")
        if !autoResource
          autoResource = Resource.new
          autoResource.resource_type_id = rtype.id
          autoResource.name = "#{r["Site"]}-autoCE"
          Rails.logger.info "#{r["Site"]}: Creating Resource: #{autoResource.name}"
          autoResource.site_id = @@sitesCache[r["Site"]]
          autoResource.save
        end
        autoResource = Resource.find_by_name("#{r["Site"]}-autoCE") #Reload resource in case it has just been created, shoul find better coding
        autoPublisher = Publisher.new
        autoPublisher.hostname = r["MachineName"]
        Rails.logger.info "Creating Publisher: #{autoPublisher.hostname}"
        autoPublisher.resource_id = autoResource.id
        autoPublisher.ip = "127.0.0.1"
        autoPublisher.save
        publisher = Publisher.includes(:resource).where('resources.site_id' => @@sitesCache[r["Site"]] ).find_by_hostname(r["MachineName"])
        @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"] = publisher.id
      else
        @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"] = publisher.id
      end
    end
    
    if @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"]
      e = ApelSsmRecord.new
      e.machineName = r["MachineName"]
      e.submitHost = r["SubmitHost"]
      e.localJobId = r["LocalJobId"]
      e.publisher_id = @@publishersCache["#{r["Site"]}.#{r["MachineName"]}"]
      e.queue = r["Queue"]
      e.recordDate = Time.at(r["EndTime"].to_i).strftime("%Y-%m-%d %H:%M:%S") #LRMS do log at the end of the job
      e.processors = r["Processors"]
      e.nodeCount = r["NodeCount"]
      e.cpuDuration = r["CpuDuration"] #seconds
      e.memoryReal = r["MemoryReal"] #KBytes
      e.memoryVirtual = r["MemoryVirtual"] #Kbytes
      e.wallDuration = r["WallDuration"] #seconds
      e.startTime = r["StartTime"]
      e.endTime = r["EndTime"]
      e.localUserId = r["LocalUserId"]
      e.recordDate = Time.at(r["StartTime"].to_i).strftime("%Y-%m-%d %H:%M:%S")#FIXME why both start and end?
      e.globalUserName = r["GlobalUserName"]
      e.fqan = r["FQAN"]
      e.vo = r["VO"]
      e.voGroup = r["VOGroup"]
      e.voRole = r["VORole"]
      e.infrastructureDescription = r["InfrastructureDescription"]
      e.infrastructureType = r["InfrastructureType"]
      if ( (r["StartTime"] == "0" && r["WallDuration"] != "0") || (r["EndTime"] == "0" && r["WallDuration"] != "0"))   ##Expunge Record with starttime at 0 (Start of the epoch)
        Rails.logger.info "#{r["Site"]}: startTime or endTime at the beginning of the Epoch. And Non zero values, skipping record!"
      else
        @@record_ary << e
      end
      @@recordCount = @@recordCount + 1;
      if ( @@record_ary.length >= @n )
        self.import
      end
    else
       Rails.logger.info "Publisher does not exists. Error!"
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
        valueBuff = ActiveRecord::Base::sanitize($2.chomp)
        key = $1
        valueBuff =~ /^'(.*)'$/
        value = $1
        recordBuff[key] = value
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
      
      @options[:user] = ''
      opt.on( '-u', '--user user', 'AMQ username for authentication') do |user|
        @options[:user] = user
      end
      
      @options[:password] = ''
      opt.on( '-p', '--password password', 'AMQ password') do |password|
        @options[:password] = password
      end
      
      @options[:deaddir] = nil
      opt.on( '-D', '--Deaddir path', 'Path to directory used as dead letter repository, for apel SSM to resend it to queue') do |dir|
        @options[:deaddir] = dir
      end
      
      @options[:backupDir] = nil
      opt.on( '-b', '--backupdirr path', 'Path to directory used as backup msg repository') do |dir|
        @options[:backupDir] = dir
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
    user = @options[:user]
    password = @options[:password]
    @count = 0
    Logger.log "Broker: #{host}, port: #{port}"
    begin
      @conn = Stomp::Connection.open user, password, host, port, false
      @conn.subscribe "/queue/#{@options[:queue]}"
    rescue Exception => e
      Logger.log "Got exception: #{e.message}"
      if @conn.open?
        @conn.disconnect
      end
    end
    while @count < @options[:limit]
      records = Array.new
      begin
      timeout(@options[:timeout]) { @msg = @conn.receive }
      Logger.log "#{@options[:queue]} - Message N.#{@count}"
      rescue Timeout::Error
        @conn.unsubscribe "/queue/#{@options[:queue]}"
        @conn.disconnect
        Logger.log "#{@options[:queue]} - No more messages. Exiting."
        return
      end
      @count = @count + 1
      if @msg.command == "MESSAGE"
        ssm_msg = SSMMessage.new(@msg.body)
        Rails.logger.debug "#{ssm_msg}"
        begin
          records = ssm_msg.parse
          if ( @options[:backupDir] != nil )
            bck = DeadMessage.new(@msg.body,@options[:backupDir])
            bck.write
          end
          next if not records
          event = ApelSsmRecordConverter.new(@options[:bulk])
          benchmark = BenchmarkRecordConverter.new
          records.each do |r|
            if records.length >= @options[:bulk]
               #treat case when there are at least n records to be bulk processed
                event.convert(r)
                benchmark.convert(r)
           else
                Logger.log "#{records.length} remaining in message --> Single insert."
                #treat case where there are no sufficient record to be bulk processed
                partialEvent = ApelSsmRecordConverter.new(records.length) if not partialEvent
                benchmark = BenchmarkRecordConverter.new
                Logger.log "Do single Event"
                partialEvent.convert(r)
                benchmark.convert(r) #we do not do bulk insert for benchmarks
            end
          end
        rescue Exception => e
           Logger.log "Got Error inserting records, pushing message to dead.letter.queue"
           Logger.log "Error: #{e.message}"
           Logger.log e.backtrace.inspect
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





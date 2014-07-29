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

class CloudSsmRecordConverter
  @@record_ary = Array.new
  @@publishersCache = Hash.new
  @@recordCount = 0
  def initialize (n)
    @n = n
  end
  
  def import
    #puts @@publishersCache.to_json
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    Rails.logger.info "#{now} - Cloud SSM Record count: #{@@recordCount}"
    valuesBuffer = ""
    @@record_ary.each do |e|
      Rails.logger.debug "#{now} site:#{e.siteName} machineName:#{e.machineName}"
      if ( ! e.recordDate ) || ( ! e.localJobId )
        Rails.logger.info "#{now} #{e.to_json}"
      end
      valuesBuffer << "(NULL,#{e.publisher_id},'#{e.recordDate}','#{e.submitHost}','#{e.machineName}','#{e.queue}','#{e.localJobId}','#{e.localUserId}','#{e.globalUserName}','#{e.fqan}','#{e.vo}','#{e.voGroup}','#{e.voRole}',#{e.wallDuration},#{e.cpuDuration},#{e.processors},#{e.nodeCount},#{e.startTime},#{e.endTime},'#{e.infrastructureDescription}','#{e.infrastructureType}',#{e.memoryReal},#{e.memoryVirtual},'#{now}','#{now}')"
      if e != @@record_ary.last 
        valuesBuffer << ","
      end    
    end
    bulkInsert = "INSERT IGNORE INTO apel_ssm_records
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
    if not r["SiteName"]
      Rails.logger.info "#{r.to_json}"
    end
    if not r["ControllerName"]
      #Automatically assig a controller if not specified in the record (SSM does not foresees this field)
      r["ControllerName"] = "#{r["SiteName"]}.#{r["CloudType"]}"
    end
    if not r["PublisherName"]
      #Automatically assig a controller if not specified in the record (SSM does not foresees this field)
      r["PublisherName"] = "#{r["SiteName"]}.#{r["CloudType"]}.autoPublisher"
    end
    if not @@publishersCache.key?(r["PublisherName"])
      publisher = Publisher.find_by_hostname(r["PublisherName"])
      if !publisher
        #Publisher does not exists.
        site = Site.find_by_name(r["SiteName"])
        rtype = ResourceType.find_by_name("CloudManager") 
        autoResource = Resource.new
        autoResource.resource_type_id = rtype.id
        autoResource.name = r["ControllerName"]
        Rails.logger.info "Creating Resource: #{autoResource.name}"
        autoResource.site_id = site.id
        autoResource.save
        autoPublisher = Publisher.new
        autoPublisher.hostname = r["PublisherName"]
        Rails.logger.info "Creating Publisher: #{autoPublisher.hostname}"
        autoPublisher.resource_id = autoResource.id
        autoPublisher.ip = "127.0.0.1"
        autoPublisher.save
        publisher = Publisher.find_by_hostname(r["PublisherName"])
        @@publishersCache[r["PublisherName"]] = publisher.id
      end
      ##If publisher does not exists create it
      @@publishersCache[r["PublisherName"]] = publisher.id
    end
    
    if @@publishersCache[r["PublisherName"]]
      e = CloudSsmRecord.new
      e.controllerName = r["ControllerName"]
      e.publisherName = r["PublisherNome"]
      e.vmuuid = r["VMUUID"]
      e.siteName = r["Sitename"]
      e.machineName = r["MachineName"]
      e.submitHost = r["SubmitHost"]
      e.localJobId = r["LocalJobId"]
      e.publisher_id = @@publishersCache[r["MachineName"]]
      e.queue = r["Queue"]
      e.recordDate = Time.at(r["EndTime"].to_i).strftime("%Y-%m-%d %H:%M:%S") #LRMS do lag at the end of the job
      e.processors = r["Processors"]
      e.nodeCount = r["NodeCount"]
      e.cpuDuration = r["CpuDuration"] #seconds
      e.memoryReal = r["MemoryReal"] #KBytes
      e.memoryVirtual = r["MemoryVirtual"] #Kbytes
      e.wallDuration = r["WallDuration"] #seconds
      e.startTime = r["StartTime"]
      e.endTime = r["EndTime"]
      e.localUserId = r["LocalUserId"]
      e.recordDate = Time.at(r["StartTime"].to_i).strftime("%Y-%m-%d %H:%M:%S")
      e.globalUserName = r["GlobalUserName"]
      e.fqan = r["FQAN"]
      e.vo = r["VO"]
      e.voGroup = r["VOGroup"]
      e.voRole = r["VORole"]
      e.infrastructureDescription = r["InfrastructureDescription"]
      e.infrastructureType = r["InfrastructureType"]
    
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
          if ( @options[:backupDir] != nil )
            bck = DeadMessage.new(@msg.body,@options[:backupDir])
            bck.write
          end
          next if not records
          event = ApelSsmRecordConverter.new(@options[:bulk])
          records.each do |r|
            if records.length >= @options[:bulk]
               #treat case when there are at least n records to be bulk processed
                event.convert(r)
                benchmark.convert(r)
           else
                Rails.logger.info "#{records.length} remaining in message --> Single insert."
                #treat case where there are no sufficient record to be bulk processed
                partialEvent = EventRecordConverter.new(records.length) if not partialEvent
                Rails.logger.debug "Do single Event"
                partialEvent.convert(r)
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




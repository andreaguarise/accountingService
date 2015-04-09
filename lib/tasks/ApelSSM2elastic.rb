require 'optparse'
require 'timeout'
require 'elasticsearch'

class Logger

  
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
    #Rails.logger.info @@record_ary.to_json
    bulk_ary= []
    @@record_ary.each do |e|
      #Rails.logger.info "#{now} date:#{e['recordStartDate']} lrmsId:#{e['localJobId']}"
      #Rails.logger.info "JSON:#{e.to_json}"
      indexBuff= "#{e['Site']}#{e['LocalJobId']}#{e['EndTime']}"
      r = {index: {_index: 'faust-test', _type: 'apel-ssm-record', _id: indexBuff,data: e}}
      bulk_ary << r  
    end
    #Rails.logger.info bulk_ary.to_json
    client = Elasticsearch::Client.new host: 'hdesk-dev-20.to.infn.it:9200'
    client.bulk body: bulk_ary
    @@record_ary.clear
  end
  
  def convert(r)
    if not r["MachineName"]
      #Logger.log "#{r.to_json}"
    end
    
      
      r["recordEndDate"] = Time.at(r["EndTime"].to_i) #LRMS do log at the end of the job
      r["recordStartDate"] = Time.at(r["StartTime"].to_i)
      if ( (r["StartTime"] == "0" && r["WallDuration"] != "0") || (r["EndTime"] == "0" && r["WallDuration"] != "0"))   ##Expunge Record with starttime at 0 (Start of the epoch)
        Rails.logger.info "#{r["Site"]}: startTime or endTime at the beginning of the Epoch. And Non zero values, skipping record!"
      else
        @@record_ary << r
      end
      @@recordCount = @@recordCount + 1;
      if ( @@record_ary.length >= @n )
        self.import
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
      line = line.chomp
      #Rails.logger.info "---#{line}---"
      if ( line =~ /^(\w+):\s(\d+)$/)
        value = $2
        key = $1
        recordBuff[key] = value.to_i
        #Rails.logger.info "#{recordBuff[key]} is an integer"
        haveApelRecord = true;
      elsif ( line =~ /^(\w+):\s(\d+)\.(\d+)$/)
        value = "#{$2}.#{$3}"
        key = $1
        recordBuff[key] = value.to_f
        #Rails.logger.info "#{recordBuff[key]} is a float"
        haveApelRecord = true;
      elsif ( line =~ /^(\w+):\s(.*)$/ )
        value = $2
        key = $1
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
      Logger.log "Reading message number: #{@count}"
      if @msg.command == "MESSAGE"
        ssm_msg = SSMMessage.new(@msg.body)
        #Rails.logger.debug "#{ssm_msg}"
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
                
           else
                Logger.log "#{records.length} remaining in message --> Single insert."
                #treat case where there are no sufficient record to be bulk processed
                partialEvent = ApelSsmRecordConverter.new(records.length) if not partialEvent
                Logger.log "Do single Event"
                partialEvent.convert(r)
                
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





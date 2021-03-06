#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'json'
require 'mysql'
require 'active_resource'

options = {}
values = {}

class GenericResource < ActiveResource::Base
  self.format = :xml
end

class Publisher < GenericResource
end

class Resource < GenericResource
end 

class Site < GenericResource
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

class SSMrecord
  def initialize(row)
    @row = row
  end
  
  def machineName
    if /^(.*):.*$/.match(@row['gridResource'])
      $1
    end  
  end
  
  def queue
    if /^.*:(.*)$/.match(@row['gridResource'])
      $1
    end
  end
  
  def userFQAN
    @row['userFqan']
  end
  
  def VOGroup
    if /^(.*?)\/Role=.*?$/.match(@row['userFqan']) 
      $1
    else
      ""
    end
  end
  
  def VORole
    if /^.*?\/Role=(.*?)\/.*?$/.match(@row['userFqan']) 
      "Role=#{$1}"
    else
      ""
    end
  end
  
  def processors
    count = 1 + @row['executingNodes'].count('+')
    count.to_s
  end
  
  def nodeCount
    count = 1 + @row['executingNodes'].count('+')
    count.to_s
  end
  
  def infrastructureDescription
    ""
  end
  
  def infrastructureType
    ""  
  end
   
  def to_s
    out = ""
    out += "Site: " + @row['siteName'] + "\n"
    out += "SubmitHost: " + @row['gridResource'] + "\n"
    out += "MachineName: " + self.machineName + "\n"
    out += "Queue: " + self.queue + "\n"
    out += "LocalJobId: " + @row['lrmsId'] + "\n"
    out += "LocalUserId: " + @row['localUserId'] + "\n"
    out += "GlobalUserName: " + @row['gridUser'] + "\n"
    out += "FQAN: " + self.userFQAN + "\n"
    out += "VO: " + @row['userVo'] + "\n"
    out += "VOGroup: " + self.VOGroup + "\n"
    out += "VORole: " + self.VORole + "\n"
    out += "WallDuration: " + @row['wallTime'] + "\n"
    out += "CpuDuration: " + @row['cpuTime'] + "\n"
    out += "Processors: " + self.processors + "\n"
    out += "NodeCount: " + self.nodeCount + "\n"
    out += "StartTime: " + @row['start'] + "\n"
    out += "EndTime: " + @row['end'] + "\n"
    out += "InfrastructureDescription: " + self.infrastructureDescription + "\n"
    out += "InfrastructureType: " + self.infrastructureType + "\n"
    out += "MemoryReal: " + @row['pmem'] + "\n"
    out += "MemoryVirtual: " + @row['vmem'] + "\n"
    out += "ServiceLevelType: " + @row['iBenchType'] + "\n"
    out += "ServiceLevel: " + @row['iBench'] + "\n"
    out += "%%\n"
  end
end

class SSMmessage
  def initialize(dir,file)
    @dir = dir
    @file = file
    @message = "APEL-individual-job-message: v0.3\n"
  end
  
  def addRecord(r)
    @message += r.to_s
  end
  
  def write   
    open("#{@dir}/#{@file}", "a") { |f| f << @message }
  end
  
end

class HlrSiteResource
  def initialize
    @h = {} #hash with gridResource stripped to hostname (the publisher) as key and siteName as value 
  end
  
  def addItem(gridResource,siteName)
    if !@h.has_key?(gridResource)
      @h[self.publisher(gridResource)] = siteName
    end
  end
  
  def resource(gridSite)
    "#{gridSite}-grid-CE"
  end
  
  def publisher(gridResource)
    if /^(.*):.*$/.match(gridResource)
      $1
    end  
  end
  
  def site_to_h(name)
    rh = {}
    rh['name'] = name
    rh['description'] = "Addded by hlr2ssm"
    rh
  end
  
  def resource_to_h(site)
    rh = {}
    rh['name'] = self.resource(site)
    rh['site_name'] = site
    rh['resource_type_name'] = "Farm_grid+local"
    rh
  end
  
  def publisher_to_h(gridResource,gridSite)
    rh = {}
    rh['hostname'] = gridResource
    rh['resource_name'] = self.resource(gridSite)
    rh['ip'] = "0.0.0.0"
    rh
  end
  
  def faustPost(uri,token)
    Site.site = uri
    Site.headers['Authorization'] = "Token token=\"#{token}\""
    Site.timeout = 5
    Site.proxy = ""
    Resource.site = uri
    Resource.headers['Authorization'] = "Token token=\"#{token}\""
    Resource.timeout = 5
    Resource.proxy = ""
    Publisher.site = uri
    Publisher.headers['Authorization'] = "Token token=\"#{token}\""
    Publisher.timeout = 5
    Publisher.proxy = ""
    @h.each do |k,v|
      #puts "#{k} --> #{self.resource(v)} --> #{v}"
      #puts self.site_to_h(v).to_json
      site = Site.new(self.site_to_h(v))
      resource = Resource.new(self.resource_to_h(v))
      publisher = Publisher.new(self.publisher_to_h(k,v))
      tries = 0
      begin
        tries += 1
        site.save
        resource.save
        publisher.save
      rescue Exception => e
        puts "Error sending  #{v}:#{e.to_s}. Retrying" # if options[:verbose]
        if ( tries < 2)
          sleep(2**tries)
          retry
        else
          puts "Could not send record #{v}."
        end
      end
    end
  end
end

class HlrDbRow
	def initialize(row)
		@row = row
	end

	def recordHashLRMS
	  rh = {}
    rh['recordDate'] = @row['date']
    rh['user'] = @row['localUserId']
    #rh[''] = @row['server']
    rh['lrmsId'] = @row['lrmsId']
    if /^.*:(.*)$/.match(@row['gridResource'])
      rh['queue'] = $1
    end
    rh['resourceUsed_cput'] = @row['cpuTime']
    rh['resourceUsed_walltime'] = @row['wallTime']
    rh['resourceUsed_vmem'] = @row['vmem']
    rh['resourceUsed_mem'] = @row['pmem']
    #rh[''] = @row['processors']
    rh['group'] = @row['localGroup']
    #rh['jobName'] = @row['jobName']
    rh['ctime'] = @row['start']
    rh['qtime'] = @row['start']
    rh['etime'] = @row['start']
    rh['start'] = @row['start']
    rh['end'] = @row['end']
    rh['execHost'] = @row['executingNodes']
    rh['exitStatus'] = "0"
    rh
	end

  def recordHashBlah
    rh = {}
    rh['ceId'] = @row['gridResource']
    rh['clientId'] = @row['dgJobId']
    rh['jobId'] = @row['dgJobId']
    rh['localUser'] = @row['localUserId']
    rh['lrmsId'] = @row['lrmsId']
    rh['recordDate'] = @row['date']
    rh['timestamp'] = @row['date']
    rh['userDN'] = @row['gridUser']
    rh['userFQAN'] = @row['userFqan']
    rh
  end

end

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: record_post [OPTIONS] field=value ..."

  options[:verbose] = false
  opt.on( '-v', '--verbose', 'Output more information') do
    options[:verbose] = true
  end
  
  options[:dryrun] = false
  opt.on( '-d', '--dryrun', 'Do not talk to server') do
    options[:dryrun] = true
  end
  
  options[:dir] = nil
  opt.on( '-D', '--Dir dir', 'Output dir to store SSM files') do |dir|
    options[:dir] = dir
  end
  
  options[:num] = 1000
  opt.on( '-n', '--num num', 'num records per message') do |num|
    options[:num] = num
  end
  
  options[:uri] = nil
      opt.on( '-U', '--URI uri', 'URI to contact') do |uri|
        options[:uri] = uri
      end
  
  options[:token] = nil
  opt.on( '-t', '--token token', 'Authorization token that must be obtained from the service administrator') do |token|
       options[:token] = token
  end

  opt.on( '-h', '--help', 'Print this screen') do
    puts opt
    exit
  end
end

opt_parser.parse!

ARGV.each do |f|
  f =~/(.*)=(.*)/
  data = Regexp.last_match
  values[data[1]] = data[2]
end

$stdout.sync = true

begin
	con = Mysql.new values['dbhost'], values['dbuser'], values['dbpasswd'], values['dbname']
	firstlast = con.query("SELECT min(id) as min_id, max(id) as max_id FROM jobTransSummary")
	r = firstlast.fetch_row
	stop_id = r[1]
  current_id = r[0]
	stop_id = values['stop_id'] if values['stop_id']
	current_id = values['start_id'] if values['start_id']
	puts "Start from #{current_id}, stop at #{stop_id}"
	until current_id.to_i > stop_id.to_i
	  
		rs = con.query("SELECT * FROM jobTransSummary WHERE id > #{current_id} ORDER BY id LIMIT #{options[:num]}")
		n_rows = rs.num_rows
		dirq= DirQ.new(options[:dir])
    filename = dirq.dir + "/" + dirq.file
		message = SSMmessage.new(options[:dir],filename)
		resourceSite = HlrSiteResource.new
		rs.each_hash do |row|
		  ###COMPOSE AND WRITE MESSAGESE HERE  
		  record = SSMrecord.new(row)
		  message.addRecord(record)
		  current_id = row['id'] 
		  #FIND hlr:siteName,gridResource and produce faust:site,resource,publisher
		  resourceSite.addItem(row['gridResource'],row['siteName']) 
		end
		#then use FAUST rest api to create site,resource,publisher on faust before writing record down to the broker 
		resourceSite.faustPost(options[:uri],options[:token])
		if !options[:dryrun] 
		  message.write
		end
    puts "current_id:#{current_id}, going to #{stop_id} in #{filename}"
	end

rescue Mysql::Error => e
	puts e.errno
	puts e.error
ensure
	con.close if con
end



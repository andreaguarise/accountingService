#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'graphite-api'
require 'open-uri'
require 'table2graphite_defs'


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

class Message
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

class Table
  def initialize (obj, timeField,startId,stopId)
    @startId = startId
    @stopId = stopId
    @tableName = obj.table_name
    @obj = obj
    @timeField = timeField
  end
  
  def result
    result = @obj
    if @stopId != -1
      result = result.where("`cpu_grid_norm_records`.`id`<='#{@stopId}'") 
    end 
    result
  end
  
  def tableName
    @tableName
  end
  
  def timeField
    @timeField
  end
end

class BaseGraph
  def initialize(options)
    @options = options
  end
  
    
  def uenc(s)
    enc = s.mgsub([[/\./ , '_'],[/\// , '_'],[/\ / , '_'],[/=/ , '_']])
    enc
  end
end

class ELData < BaseGraph

  def defs
    startId = 0
    stopId = -1
    if (@options[:fromId] == "")
      startid = CpuGridNormRecord.select(:id).order(:id).first.id
    end
    if (@options[:toId] == "")
      stopid = CpuGridNormRecord.select(:id).order(:id).last.id
    end
    puts "startid: #{startid} - stopid: #{stopid}"
    t= Table.new(CpuGridNormRecord,"recordDate",startid,stopid)
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value => [:benchmark_type])
      result = result.select(
	  ["recordDate",
	  "`cpu_grid_norm_records`.`id` as id",
          "`sites`.`name`",
	  "vo",
          "wallDuration", 
          "cpuDuration",
          "memoryReal",
          "memoryVirtual",
          "benchmark_values.value as benchmarkValue",
          "processors", 
          "benchmark_types.name as benchmarkName",
	  "startTime",
	  "endTime",
	  "infrastructureType",
	  "localJobId",
	  "localUserId",
	  "queue",
	  "submitHost",
	  "localJobId",
	  "globalUserName",
	  "fqan",
	  "voRole",
	  "vogroup"
	])
      index=1
      time0 = Time.now.to_i
      result.find_each(start: startid, batch_size: 1000) do |r|
          uniqueId=uenc("#{r['submitHost']}-#{r['endTime']}-#{r['localJobId']}")
       	  puts "#{index} -- #{r['recordDate']} -- #{uniqueId} -->  #{r.to_json}" 
          #system "curl -X PUT http://#{@options[:elasticUrl]}/faust/cpuGridNorm/#{uniqueId}  --data-ascii '#{r.to_json}'" 
	     if !@options[:dryrun] 
          #@gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
       end
	  index = index +1
	  time1 = Time.now.to_i
	  freq = index.to_f/(time1.to_f-time0.to_f)
	  puts "freq: #{freq} records/s"
#          sleep(@options[:sleep])
      end
  end
  
end



class String
  def mgsub(key_value_pairs=[].freeze)
         regexp_fragments = key_value_pairs.collect { |k,v| k }
         gsub(Regexp.union(*regexp_fragments)) do |match|
           key_value_pairs.detect{|k,v| k =~ match}[1]
         end
  end
end





class DbToElasticsearch
  def initialize
    @options = {}
  end
  
  def getLineParameters
    
    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: table2gelasticsearch.rb [OPTIONS]"

      @options[:verbose] = false
      opt.on( '-v', '--verbose', 'Output more information') do
        @options[:verbose] = true
      end
      
      @options[:dryrun] = false
      opt.on( '-D', '--DRYRUN', 'do not populate graphite') do
        @options[:dryrun] = true
      end
      
      @options[:env] = nil
      opt.on( '-e', '--environment env', 'rails environment') do |env|
        @options[:env] = env
      end
      
      @options[:elasticUrl] = "localhost:2003"
      opt.on( '-E', '--elasticUrl url', 'elasticsearch contact url') do |elasticUrl|
        @options[:elasticUrl] = elasticUrl
      end
      
      @options[:fromId] = ""
      opt.on( '-f', '--fromId date', 'start id') do |id|
        @options[:fromId] = id
      end
      
      @options[:toId] = ""
      opt.on( '-t', '--toId date', 'optional stop id') do |toId|
        @options[:toId] = toId
      end
      
      @options[:sleep] = 0.001
      opt.on( '-s', '--sleep sleep', 'pause per insert, default 0.001 secs') do |sleep|
        @options[:sleep] = sleep.to_f
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
    g = ELData.new(@options)
    g.defs
  end
  
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

db2elasticsearch = DbToElasticsearch.new
db2elasticsearch.main


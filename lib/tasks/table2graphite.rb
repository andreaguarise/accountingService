#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'graphite-api'

class Table
  def initialize (obj, timeField,fromDate )
    @fromDate = fromDate
    @tableName = obj.table_name
    @obj = obj
    @timeField = timeField
  end
  
  def result
    result = @obj.select("date(#{@timeField}) as d, 
          hour(#{@timeField}) as h")
    result = result.select("
          UNIX_TIMESTAMP(#{@timeField}) as timestamp")
    result = result.where("#{@timeField}>'#{@fromDate}'")
    result = result.group("d,h")
  end
  
  def tableName
    @tableName
  end
  
  def timeField
    @timeField
  end
end

class DbToGraphite
  def initialize
    @options = {}
  end
  
  def getLineParameters
    
    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: db2graphite.rb [OPTIONS]"

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
      
      @options[:graphiteUrl] = "localhost:2003"
      opt.on( '-G', '--graphiteUrl url', 'graphite contact url') do |graphiteUrl|
        @options[:graphiteUrl] = graphiteUrl
      end
      
      @options[:date] = "2014-01-01"
      opt.on( '-d', '--date date', 'start date') do |date|
        @options[:date] = date
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
    client = GraphiteAPI.new( :graphite => @options[:graphiteUrl] )
    ##INSERT HERE BLOCKS FOR query/metrics import
    
      t= Table.new(CpuGridNormRecord,"recordDate",@options[:date])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.select("
          `sites`.`name` as siteName , vo,
          sum(wallDuration) as wallDuration, 
          sum(cpuDuration) as cpuDuration, 
          count(*) as count")
      result = result.group("siteName,vo")
      result.each do |r|
        puts "#{r['siteName']} ---- date: #{r['d']} #{r['h']},#{r['vo']}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records.by_site.#{r['siteName']}.by_vo.#{r['vo']}.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{r['siteName']}.by_vo.#{r['vo']}.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{r['siteName']}.by_vo.#{r['vo']}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{r['vo']}.by_site.#{r['siteName']}.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{r['vo']}.by_site.#{r['siteName']}.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{r['vo']}.by_site.#{r['siteName']}.count" => r['count']
            }
        if !@options[:dryrun] 
          client.metrics(metrs,Time.at(r['timestamp'].to_i))
        end
      end
    ##
  end
  
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

db2graphite = DbToGraphite.new
db2graphite.main




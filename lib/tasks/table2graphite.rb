#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'graphite-api'
require 'open-uri'

class String
  def mgsub(key_value_pairs=[].freeze)
         regexp_fragments = key_value_pairs.collect { |k,v| k }
         gsub(Regexp.union(*regexp_fragments)) do |match|
           key_value_pairs.detect{|k,v| k =~ match}[1]
         end
  end
end

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
  
  
  
  def uenc(s)
    enc = s.mgsub([[/\./ , '_'],[/\// , '_']])
    enc
  end
  
  def main
    self.getLineParameters
    client = GraphiteAPI.new( :graphite => @options[:graphiteUrl] )
    ##INSERT HERE BLOCKS FOR query/metrics import
    
      t= Table.new(CpuGridNormRecord,"recordDate",@options[:date])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select("
          `sites`.`name` as siteName , vo,
          sum(wallDuration) as wallDuration, 
          sum(cpuDuration) as cpuDuration,
          sum(memoryReal) as memoryReal,
          sum(memoryVirtual) as memoryVirtual,
          avg(benchmark_values.value) as benchmarkValue, 
          count(*) as count")
      result = result.group("siteName,vo")
      result.each do |r|
        puts "#{r['siteName']} ---- date: #{r['d']} #{r['h']},#{uenc(r['vo'])}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryVirtual" => r['memoryVirtual'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryReal" => r['memoryReal'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.si2k" => r['benchmarkValue'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryVirtual" => r['memoryVirtual'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryReal" => r['memoryReal'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          client.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
      end
    ##
    
    t= Table.new(CpuGridNormRecord,"recordDate",@options[:date])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select("
          `sites`.`name` as siteName,
          sum(wallDuration) as wallDuration, 
          sum(cpuDuration) as cpuDuration,
          sum(memoryReal) as memoryReal,
          sum(memoryVirtual) as memoryVirtual,
          avg(benchmark_values.value) as benchmarkValue, 
          count(*) as count")
      result = result.group("siteName")
      result.each do |r|
        puts "#{r['siteName']} ---- date: #{r['d']} #{r['h']}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo..wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.memoryVirtual" => r['memoryVirtual'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.memoryReal" => r['memoryReal'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          client.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
      end
    ##
    t= Table.new(CpuGridNormRecord,"recordDate",@options[:date])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select("
          vo,
          sum(wallDuration) as wallDuration, 
          sum(cpuDuration) as cpuDuration,
          sum(memoryReal) as memoryReal,
          sum(memoryVirtual) as memoryVirtual,
          avg(benchmark_values.value) as benchmarkValue, 
          count(*) as count")
      result = result.group("vo")
      result.each do |r|
        puts "#{r['siteName']} ---- date: #{"#{r['d']} #{r['h']}:00".to_datetime},#{uenc(r['vo'])}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.cpuDuration" => r['cpuDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.memoryVirtual" => r['memoryVirtual'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.memoryReal" => r['memoryReal'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          client.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
      end
    ##
    t= Table.new(CloudRecordSummary,"date",@options[:date])
      result = t.result.joins(:site)
      result = result.select("
          `sites`.`name` as siteName,
          local_group,
          local_user,
          status,
          vmCount, 
          cpuDuration,
          wallDuration,
          networkInbound,
          networkOutbound,
          cpuCount,
          memory")
          result = result.group("siteName,local_group,local_user,status")
      result.each do |r|
        puts "#{r['siteName']} - #{r['local_user']}---- date: #{"#{r['d']} #{r['h']}:00".to_datetime}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['vmCount']}"
        metrs = {
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.vmCount" => r['vmCount'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkInbound" => r['networkInbound'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkOutbound" => r['networkOutbound'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuCount" => r['cpuCount'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.memory" => r['memory'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.wallDuration" => r['wallDuration'].to_f/3600,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuDuration" => r['cpuDuration'].to_f/3600
            }
        if !@options[:dryrun] 
          client.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
      end
    
  end
  
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

db2graphite = DbToGraphite.new
db2graphite.main



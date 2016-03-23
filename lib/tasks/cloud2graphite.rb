#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'graphite-api'
require 'open-uri'
require 'cloud2graphite_defs'

class String
  def mgsub(key_value_pairs=[].freeze)
         regexp_fragments = key_value_pairs.collect { |k,v| k }
         gsub(Regexp.union(*regexp_fragments)) do |match|
           key_value_pairs.detect{|k,v| k =~ match}[1]
         end
  end
end

class Table
  def initialize (obj, timeField,fromDate,toDate,site)
    @fromDate = fromDate
    @toDate = toDate
    @site = site
    @tableName = obj.table_name
    @obj = obj
    @timeField = timeField
  end
  
  def result
    start_end = "#{@timeField}>'#{@fromDate}'"
    if @toDate != ""
      start_end = "#{start_end} AND #{@timeField}<='#{@toDate}'" 
    end
    sql = "SELECT
	\"INFN-TORINO\" as siteName, 
	endTime,
	date(endTime) as d,	
	hour(endTime) as h,
	minute(endtime) as m,
	local_user,
	local_group,
	count(localVMID) as vmCount,
	sum(cpuCount) cpuCount,
	sum(disk) as disk,
	sum(memory) as memory,
	sum(cpuDuration) as cpuDuration,
	sum(wallDuration) as wallDuration,
	sum(networkInbound) as networkInbound,
	sum(networkOutbound) as networkOutbound,
	status
	FROM (SELECT  `cloud_records`.`id` AS `id`, 
		endTime as endTime,
		date(endTime) as d,	
		hour(endTime) as h,
		minute(endtime) as m,
		`cloud_records`.`VMUUID` AS `VMUUID`, 
		localVMID, 
		publisher_id as publisher_id,
		local_user,
		local_group, 
		status,
		`cloud_records`.`diskImage` AS `diskImage`,
		`cloud_records`.`cloudType` AS `cloudType`, 
		max(disk) as disk,
		max(wallDuration) as wallDuration,
		max(cpuDuration) as cpuDuration,
		max(networkInbound) as networkInbound,
		max(networkOutbound) as networkOutbound,
		max(memory) as memory,
		max(cpuCount) as cpuCount 
FROM cloud_records WHERE #{start_end} group by d,h,m,localVMID,status ) AS cloud_records group by d,h,m,local_user,local_group,status " 
    #if @site != ""
    #  result = result.where("`sites`.`name` = '#{@site}'")
    #end
    #result = result.group("d,h,m")
    result = ActiveRecord::Base.connection.execute(sql)
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
      
      @options[:site] = ""
      opt.on( '-S', '--Site site', 'select a specific Site') do |site|
        @options[:site] = site
      end
      
      @options[:graphiteUrl] = "localhost:2003"
      opt.on( '-G', '--graphiteUrl url', 'graphite contact url') do |graphiteUrl|
        @options[:graphiteUrl] = graphiteUrl
      end
      
      @options[:date] = "2014-01-01"
      opt.on( '-d', '--date date', 'start date') do |date|
        @options[:date] = date
      end
      
      @options[:noMetric] = ""
      opt.on( '-n', '--noMetric metricList', 'list of metrics to skip') do |noMetric|
        @options[:noMetric] = noMetric
      end
      
      @options[:toDate] = ""
      opt.on( '-t', '--toDate date', 'optional stop date') do |toDate|
        @options[:toDate] = toDate
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
    client = GraphiteAPI.new( :graphite => @options[:graphiteUrl] )
    g = Graphics.new(@options,client)
    g.defs
  end
  
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

db2graphite = DbToGraphite.new
db2graphite.main





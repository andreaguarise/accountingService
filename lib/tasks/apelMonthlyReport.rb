#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'open-uri'

class Table
  def initialize (obj, timeField,startDate,stopDate,site)
    @startDate = startDate
    @stopDate = stopDate
    @site = site
    @tableName = obj.table_name
    @obj = obj
    @timeField = timeField
  end
  
  def result
    result = @obj
    if @stopDate != ""
      result = result.where("#{timeField}<'#{@stopDate}'") 
    end 
    if @startDate != ""
      result = result.where("#{timeField}>='#{@startDate}'") 
    end 
    if @site != ""
      result = result.where("sites.name = '#{@site}'")
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
  
  def print record
    content = "siteName  Year  Month  vo  count  wall_H  wall_H_ksi2k  \\n"
    record.each do |r| 
      content += "#{r['siteName']}   #{r['year']}  #{r['month']}  #{r['vo']}  #{r['count']}  #{r['wall_H'].round(2)} #{r['wall_H_ksi2k'].round(2)}  \\n"
    end
    navigation = '<a href=\"./#/dashboard/script/grid-base.js?siteName=*\">Grid Dashboard</a>' 
    info = "Last updated on: " + Date.today.to_s
    puts '{
  "rows": [
    {
      "title": "Summary",
      "height": "70px",
      "editable": false,
      "collapse": false,
      "collapsable": true,
      "panels": [
        {
          "error": false,
          "span": 5,
          "editable": false,
          "type": "text",
          "mode": "html",
          "content": "' + navigation + '",
          "title": "Navigation"
        },
        {
          "error": false,
          "span": 7,
          "editable": false,
          "type": "text",
          "mode": "markdown",
          "content": "' + info + '"
      ,"style": {},
          "title": "Info"
        }
      ],
      "notice": false
    },
    {
      "title": "Statistics",
      "height": "800px",
      "editable": true,
      "collapse": false,
      "collapsable": true,
      "panels": [
        {
          "error": false,
          "span": 12,
          "editable": true,
          "type": "text",
          "mode": "markdown",
          "content": "' + content + '"
      ,"style": {},
          "title": "Monthly report"
        }
      ],
      "notice": false
    }
  ],
  "services": {
    "filter": {
      "time": {
        "from": "now-30d",
        "to": "now"
      }
    }
  },
  "title": "Summary",
  "editable": "false",
  "style": "light",
  "panel_hints": "false",
  "loader": {
    "save_gist": false,
    "save_elasticsearch": true,
    "save_local": true,
    "save_default": false,
    "save_temp": false,
    "save_temp_ttl_enable": false,
    "save_temp_ttl": "30d",
    "load_gist": false,
    "load_elasticsearch": true,
    "load_elasticsearch_size": 20,
    "load_local": true,
    "hide": true
  },
  "tags": [],
  "timezone": "browser",
  "failover": false,
  "pulldowns": [
    {
      "type": "templating"
    },
    {
      "type": "annotations"
    },
    {
      "type": "filtering",
      "enable": false
    }
  ],
  "nav": [
    {
      "type": "timepicker",
      "collapse": false,
      "notice": false,
      "enable": true,
      "status": "Stable",
      "time_options": [
        "12h",
        "24h",
        "2d",
        "7d",
        "30d"
      ],
      "refresh_intervals": [
        "5m",
        "15m",
        "30m",
        "1h",
        "2h",
        "1d"
      ],
      "now": true
    }
  ],
  "refresh": false
}'
  end

  def defs
    t= Table.new(CpuGridNormRecord,"FROM_UNIXTIME(endTime)",@options[:fromDate],@options[:toDate],@options[:site])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select(
	  ["year(FROM_UNIXTIME(endTime)) as year",
	    "month(FROM_UNIXTIME(endTime)) as month",
       "`sites`.`name` as siteName",
	     "vo",
       "sum(wallDuration)/3600 as wall_H", 
       "count(*) as count",
       "sum(benchmark_values.value*wallDuration)/3600000 as wall_H_ksi2k"
	])
      result = result.group("siteName,year,month,vo")
      result = result.order("siteName,year,month,vo")
      time0 = Time.now.to_i
      if @options[:verbose]
        puts result.to_sql
      end
      print result
      #result.each do |r|
       #	  puts "#{index} -- #{r.to_json}" 
	    #   index = index +1
      #end
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





class ApelMonthlyReport
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
      
      @options[:env] = nil
      opt.on( '-e', '--environment env', 'rails environment') do |env|
        @options[:env] = env
      end
      
      @options[:fromDate] = ""
      opt.on( '-f', '--fromdate date', 'start date') do |date|
        @options[:fromDate] = date
      end
      
      @options[:toDate] = ""
      opt.on( '-t', '--toDate date', 'optional date') do |toDate|
        @options[:toDate] = toDate
      end
      
      @options[:site] = ""
      opt.on( '-s', '--site site', 'optional siteName') do |site|
        @options[:site] = site
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

apelMonthlyReport = ApelMonthlyReport.new
apelMonthlyReport.main


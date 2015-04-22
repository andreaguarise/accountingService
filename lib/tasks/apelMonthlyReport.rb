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
      result = result.where("`cpu_grid_norm_records`.`#{timeField}`<'#{@stopDate}'") 
    end 
    if @startDate != ""
      result = result.where("`cpu_grid_norm_records`.`#{timeField}`>='#{@startDate}'") 
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

  def defs
    t= Table.new(CpuGridNormRecord,"recordDate",@options[:fromDate],@options[:toDate],@options[:site])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select(
	  ["year(recordDate) as year",
	    "month(recordDate) as month",
       "`sites`.`name` as siteName",
	     "vo",
       "sum(wallDuration)/3600", 
       "count(*) as count",
       "(benchmark_values.value*wallDuration)/3600000 as wall_H_ksi2k"
	])
      index=1
      time0 = Time.now.to_i
      if @options[:verbose]
        puts result.to_sql
      end
      result.each do |r|
       	  puts "#{index} -- #{r.to_json}" 
	       index = index +1
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
        @options[:toDate] = todate
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


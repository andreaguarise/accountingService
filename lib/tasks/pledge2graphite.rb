#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'graphite-api'
require 'open-uri'
require 'pledge2graphite_defs'

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




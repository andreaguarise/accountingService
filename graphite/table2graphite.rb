#!/usr/bin/ruby -w
require 'rubygems'
require 'optparse'
require 'date'
require 'mysql'
require 'graphite-api'

class Database
  def initialize (dbhost, dbuser, dbpassword, dbname,port)
    @dbhost = dbhost
    @dbuser = dbuser
    @dbpassword = dbpassword
    @dbname = dbname
    @port = port

  end

  def connect
    con = Mysql.new(@dbhost,@dbuser,@dbpassword,@dbname,@port)
  end

end

class Table
  def initialize (database, tableName, timeField, indexField)
    @tableName = tableName
    @timeField = timeField
    @indexField = indexField
    @database = database
  end

  def getRows(date)
    begin
      con = @database.connect
      tables = con.list_tables
      result = con.query("SELECT date(recordDate) as d, hour(recordDate) as h,UNIX_TIMESTAMP(recordDate) as timestamp,localUser as u,sum(wallt) as wallt, sum(cput) as cput, count(id) as count from #{@tableName} where #{@timeField}>'#{@date}' group by d,h,u order by d,h")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      con.close if con
    end
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
      
      @options[:env] = nil
      opt.on( '-e', '--environment env', 'rails environment') do |env|
        @options[:env] = env
      end
      
      @options[:graphiteUrl] = "localhost:2003"
      opt.on( '-G', '--graphiteUrl url', 'graphite contact url') do |graphiteUrl|
        @options[:graphiteUrl] = graphiteUrl
      end
      
      @options[:dbHost] = ""
      opt.on( '-H', '--dbHost dbhostname', 'database host') do |dbHost|
        @options[:dbHost] = dbHost
      end
      
      @options[:dbPort] = 3306
      opt.on( '-P', '--dbPort dbport', 'database port number') do |dbPort|
        @options[:dbPort] = dbPort.to_i
      end
      
      @options[:dbPassword] = ""
      opt.on( '-p', '--dbPassword dbpassword', 'database password') do |dbPassword|
        @options[:dbPassword] = dbPassword
      end
      
      @options[:dbUser] = ""
      opt.on( '-U', '--dbUser dbusername', 'database user') do |dbUser|
        @options[:dbUser] = dbUser
      end
      
      @options[:dbSchema] = ""
      opt.on( '-S', '--dbSchema dbschema', 'database schema name') do |dbSchema|
        @options[:dbSchema] = dbSchema
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
    db = Database.new(@options[:dbHost],@options[:dbUser],@options[:dbPassword],@options[:dbSchema],@options[:dbPort])
    date = @options[:date]
    ##INSERT HERE BLOCKS FOR query/metrics import
    
      table= Table.new(db,"cpu_grid_norm_records","recordDate","id")
      table.getRows(date).each_hash do |r|
      puts "date: #{r['d']} #{r['h']},#{r['u']}, timestamp: #{r['timestamp']}, cpuTime=#{r['resourceUsed_cput']},count=#{r['count']}"
       client.metrics({
        "faust.cpu_grid_norm_records_by_fqan.#{r['u']}.cput" => r['cput'].to_f/3600,
        "faust.cpu_grid_norm_records_by_fqan.#{r['u']}.cput" => r['cput'].to_f/3600,
        "faust.cpu_grid_norm_records_by_fqan.#{r['u']}.wallt" => r['wallt'].to_f/3600,
#       "faust.batch_execute_records.wallTime" => r['resourceUsed_walltime'].to_i/3600,
        "faust.cpu_grid_norm_records_by_fqan.#{r['u']}.count" => r['count']
#       "faust.batch_execute_records.user_#{r['localUser']}.cpuTime" => r['resourceUsed_cput'].to_i/3600,
#       "faust.batch_execute_records.user_#{r['localUser']}.wallTime" => r['resourceUsed_walltime'].to_i/3600,
#       "faust.batch_execute_records.group_#{r['localGroup']}.cpuTime" => r['resourceUsed_cput'].to_i/3600,
#       "faust.batch_execute_records.group_#{r['localGroup']}.wallTime" => r['resourceUsed_walltime'].to_i/3600
        },Time.at(r['timestamp'].to_i))
         date = r['recordDate']
      end
    ##
  end
  
end

if defined?(Rails) && (Rails.env == 'development')
  Rails.logger = Logger.new(STDOUT)
end

db2graphite = DbToGraphite.new
db2graphite.main




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

client = GraphiteAPI.new( :graphite => 'localhost:2003' )
db = Database.new("dgas-services.to.infn.it","root","z1b1bb0","accountingService_devel",3306)
table= Table.new(db,"cpu_grid_norm_records","recordDate","id")
id = 0;
date = '2014-05-01'
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

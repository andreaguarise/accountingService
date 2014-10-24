class BaseGraph
  def initialize(options,client)
    @options = options
    @gClient= client
  end
  
    
  def uenc(s)
    enc = s.mgsub([[/\./ , '_'],[/\// , '_'],[/\ / , '_'],[/=/ , '_']])
    enc
  end
end

class Graphics < BaseGraph

  def defs
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
        puts "#{r['siteName']} ---- date:  #{r['d']} #{r['h']},#{uenc(r['vo'])}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.si2k" => r['benchmarkValue'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
      end
    ##
    t= Table.new(CpuGridNormRecord,"recordDate",@options[:date])
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select("
          `sites`.`name` as siteName , vo, voGroup, voRole,
          sum(wallDuration) as wallDuration, 
          sum(cpuDuration) as cpuDuration,
          sum(memoryReal) as memoryReal,
          sum(memoryVirtual) as memoryVirtual,
          avg(benchmark_values.value) as benchmarkValue, 
          count(*) as count")
      result = result.group("siteName,vo,voGroup,voRole")
      result.each do |r|
        puts "#{r['siteName']} ---- date:  #{r['d']} #{r['h']},#{uenc(r['vo'])}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
        metrs = {
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.count" => r['count'],
            "faust.cpu_grid_norm_records_voGroup_voRole.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.si2k" => r['benchmarkValue'],
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.count" => r['count'],
            "faust.cpu_grid_norm_records_voGroup_voRole.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.by_voGroup.#{uenc(r['voGroup'])}.by_voRole.#{uenc(r['voRole'])}.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
      end
    ##
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
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_vo.#{uenc(r['vo'])}.si2k" => r['benchmarkValue'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
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
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.all_vo.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
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
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.count" => r['count'],
            "faust.cpu_grid_norm_records.by_vo.#{uenc(r['vo'])}.all_site.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
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
          memory,
          disk")
          result = result.group("siteName,local_group,local_user,status")
      result.each do |r|
        puts "#{r['siteName']} - #{r['local_user']}---- date: #{"#{r['d']} #{r['h']}:00".to_datetime}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['vmCount']}"
        metrs = {
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.vmCount" => r['vmCount'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkInbound" => r['networkInbound'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkOutbound" => r['networkOutbound'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuCount" => r['cpuCount'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.memory" => r['memory'].to_f*1048576,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.disk" => r['disk'].to_f*1048576,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_cloud_records.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuDuration" => r['cpuDuration'].to_f
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
      end
  end
  
end
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
    if !@options[:noMetric].include?("cpu_cloud_records") 
      t= Table.new(CloudRecord,"endTime",@options[:date],@options[:toDate],@options[:site])
      rows = t.result
      rows.each(:as => :hash) do |r|
	if r['status'] == "started"
		r['status'] = "RUNNING" 
	end
        puts "#{r['siteName']} - #{r['local_user']}---- status:#{r['status']} date: #{"#{r['d']} #{r['h']}:#{r['m']}:00".to_datetime}, cpuDuration=#{r['cpuDuration']},count=#{r['vmCount']}"
        metrs = {
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.vmCount" => r['vmCount'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkInbound" => r['networkInbound'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.networkOutbound" => r['networkOutbound'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuCount" => r['cpuCount'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.memory" => r['memory'].to_f*1048576,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.disk" => r['disk'].to_f*1048576,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.wallDuration" => r['wallDuration'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuDuration" => r['cpuDuration'].to_f,
            "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuFraction" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
	    "faust_cloud_live.cpu_cloud_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.cpuFractionMultCpu" => (r['cpuDuration'].to_f/r['wallDuration'].to_f)*r['cpuCount'].to_f
            }
        if !@options[:dryrun] 
	   puts "#{r['endTime']}".to_datetime
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:#{r['m']}:00".to_datetime)
        end
        sleep(@options[:sleep])
      end
    end
  end
  
end

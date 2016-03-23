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
        puts "#{r['siteName']} - #{r['local_user']}---- status:#{r['status']} date: #{r['endTime']}, cpuDuration=#{r['cpuDuration']}"
        metrs = {
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.networkInbound" => r['networkInbound'].to_f,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.networkOutbound" => r['networkOutbound'].to_f,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.cpuCount" => r['cpuCount'].to_f,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.memory" => r['memory'].to_f*1048576,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.disk" => r['disk'].to_f*1048576,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.wallDuration" => r['wallDuration'].to_f,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.cpuDuration" => r['cpuDuration'].to_f,
            "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.cpuFraction" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
	    "faust_cloud_vm.vm_records_live.by_site.#{r['siteName']}.by_status.#{r['status']}.by_group.#{r['local_group']}.by_user.#{r['local_user']}.#{r['localVMID']}.cpuFractionMultCpu" => (r['cpuDuration'].to_f/r['wallDuration'].to_f)*r['cpuCount'].to_f
            }
        if !@options[:dryrun] 
	   puts "#{r['endTime']}".to_datetime
          @gClient.metrics(metrs,"#{r['endTime']}".to_datetime)
        end
        sleep(@options[:sleep])
      end
    end
  end
  
end

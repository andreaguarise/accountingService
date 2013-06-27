sites = CloudRecord.joins(:publisher,:resource,:site).select("count(*),sites.name as site_name").group("site_name")

sites.each do |site|

  #ary = CloudRecord.select("date(startTime) as d0, date(endTime) as d1, wallDuration as w, networkInbound as netIn, networkOutBound as netOut, cpuCount as cpuN").all
  ary = CloudRecord.joins(:publisher,:resource,:site).select("date(startTime) as d0, date(endTime) as d1, wallDuration as w, networkInbound as netIn, networkOutBound as netOut, cpuCount as cpuN").where("sites.name = ?",site.site_name).all
  dateH = {}
  netInH = {}
  netOutH = {}
  cpuCountH = {}
  vmCountH = {}
  ary.each do |r|
    dRange = (r[:d0].to_date..r[:d1].to_date)
    dRange.each do |d|
      buffWall = 0.0
      buffWall = dateH[d] if dateH[d]
      buffNetIn = 0.0
      buffNetIn = netInH[d] if netInH[d]
      buffNetOut = 0.0
      buffNetOut = netOutH[d] if netOutH[d]
      buffCpuCount = 0
      buffCpuCount = cpuCountH[d] if cpuCountH[d]
      buffVmCount = 0
      buffVmCount = vmCountH[d] if vmCountH[d]
      dateH[d] = (r[:w]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffWall if ((r[:d1].to_date-r[:d0].to_date) != 0)
      netInH[d] = (r[:netIn]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffNetIn if ((r[:d1].to_date-r[:d0].to_date) != 0)
      netOutH[d] = (r[:netOut]/(r[:d1].to_date-r[:d0].to_date)).to_f + buffNetOut if ((r[:d1].to_date-r[:d0].to_date) != 0)
      cpuCountH[d] = r[:cpuN] + buffCpuCount if r[:cpuN]
      vmCountH[d] = 1 + buffVmCount
    end
  end


  dateH.sort.each do |k,v|
    puts "site: #{site.site_name} - date: #{k}: #{v}, #{netInH[k]}, #{netOutH[k]}, #{cpuCountH[k]}, #{vmCountH[k]}"
  end

end

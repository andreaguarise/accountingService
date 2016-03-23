class BaseGraph
  def initialize(options,client)
    @options = options
    @gClient= client
    @transHash = {
        "sgmalice" => "alice",
        "pilalice" => "alice",
        "pilatlas" => "atlas",
        "sgmatlas" => "atlas",
        "pilcms" => "cms",
        "prdcms" => "cms",
        "pillhcb" => "lhcb",
        "sgmlhcb" => "lhcb"
        }
    @siteTransArray = ["INFN-BARI"]
  end
  
  def translateVo (vo,site)
        if @siteTransArray.include?(site)
                if @transHash.include?(vo)
                puts "site:#{site}, originalvo: #{vo}, targetvo:#{@transHash[vo]}"
                vo = @transHash[vo]
                end
        end
  vo
  end

  def uenc(s)
    enc = s.mgsub([[/\./ , '_'],[/\// , '_'],[/\ / , '_'],[/=/ , '_']])
    enc
  end
end

class Graphics < BaseGraph

  def defs
    t= Table.new(CpuGridNormRecord,"recordDate",@options[:date],@options[:toDate],@options[:site])
      lhc_vo = ['alice','pilalice','sgmalice','atlas','pilatlas','sgmatlas','cms','pilcms','sgmcms','lhcb','pillhcb','sgmlhcb','prdcms']
      result = t.result.joins(:publisher => [:resource => :site])
      result = result.joins(:benchmark_value)
      result = result.select("
          `sites`.`name` as siteName , vo,
          sum(wallDuration) as wallDuration,
          sum(wallDuration*processors) as mcwallDuration, 
          sum(cpuDuration) as cpuDuration,
          sum(memoryReal) as memoryReal,
          sum(memoryVirtual) as memoryVirtual,
          sum(processors) as processors,
          avg(benchmark_values.value) as benchmarkValue, 
          count(*) as count")
      result = result.where("vo" => lhc_vo)
      result = result.group("siteName,vo")
      
      result.each do |r|
        processors = r['processors'].to_f
        puts "#{r['siteName']} ---- date:  #{r['d']} #{r['h']},#{uenc(r['vo'])}, timestamp: #{r['timestamp']}, cpuDuration=#{r['cpuDuration']},count=#{r['count']}"
#        r['vo']=translateVo(r['vo'],r['siteName'])
	metrs = {
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.mcwall_H_KSi2k" => (r['mcwallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.processors" => processors,
            "faust.cpu_grid_norm_records.by_site.#{uenc(r['siteName'])}.by_lhc_vo.#{uenc(r['vo'])}.si2k" => r['benchmarkValue'],
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpuDuration" => r['cpuDuration'].to_f,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wallDuration" => r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.efficiency" => r['cpuDuration'].to_f/r['wallDuration'].to_f,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.cpu_H_KSi2k" => (r['cpuDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.wall_H_KSi2k" => (r['wallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.mcwall_H_KSi2k" => (r['mcwallDuration'].to_f*r['benchmarkValue'].to_f)/3600000,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryVirtual" => r['memoryVirtual'].to_f*1024,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.memoryReal" => r['memoryReal'].to_f*1024,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.count" => r['count'],
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.processors" => processors,
            "faust.cpu_grid_norm_records.by_lhc_vo.#{uenc(r['vo'])}.by_site.#{uenc(r['siteName'])}.si2k" => r['benchmarkValue']
            }
        if !@options[:dryrun] 
          @gClient.metrics(metrs,"#{r['d']} #{r['h']}:00".to_datetime)
        end
        sleep(@options[:sleep])
      end

  end
  
end

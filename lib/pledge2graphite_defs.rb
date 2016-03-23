class BaseGraph
  def initialize(options,client)
    @options = options
    @gClient= client
    @transHash = {
        "sgmalice" => "alice"
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
   t= Table.new(GridPledge,"validFrom",@options[:date])
     result = t.result.joins(:site,:benchmark_type)
     result = result.select("
          `sites`.`name` as siteName,
          `benchmark_types`.`name` as benchmark,
          validFrom,
          validTo,
          vo,
         value")
      result = result.group("siteName,vo")
    result.each do |r|
      puts "#{r['siteName']} - date: #{"#{r['validFrom']}".to_datetime} #{r['validTo'].to_datetime}  pledged: #{r['value']} #{r['benchmark']}"
      r['vo']=translateVo(r['vo'],r['siteName'])
      if !@options[:dryrun]
          d1=r['validFrom'].to_date
          d2=r['validTo'].to_date
                metrs = {
                "faust_pledge.by_site.#{r['siteName']}.by_vo.#{r['vo']}.#{r['benchmark']}" => r['value'].to_f
                }
          (d1..d2).map{ |d|
                t=d.to_time
                metrs = {
                "faust_pledge.by_site.#{r['siteName']}.by_vo.#{r['vo']}.#{r['benchmark']}" => r['value'].to_f
                }
                #client = GraphiteAPI.new( :graphite => @options[:graphiteUrl] )
      		puts "#{r['siteName']} - date: #{t}  pledged: #{r['value']} #{r['benchmark']}"

                @gClient.metrics(metrs,t)
                sleep(@options[:sleep])
          }
        end
    end

  end

end

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
   t= Table.new(GridPledge,"validFrom",@options[:date])
     result = t.result.joins(:site)
     result = result.select("
          `sites`.`name` as siteName,
          validFrom,
          validTo,
         value")
      result = result.group("siteName")
    result.each do |r|
      puts "#{r['siteName']} - date: #{"#{r['validFrom']}".to_datetime} #{r['validTo'].to_datetime}  pledged: #{r['value']}"
      if !@options[:dryrun]
          d1=r['validFrom'].to_date
          d2=r['validTo'].to_date
                metrs = {
                "faust_pledged_test.pledged.by_site.#{r['siteName']}.pledged" => r['value'].to_f
                }
          (d1..d2).map{ |d|
                        t=d.to_time
                metrs = {
                        "faust_pledged_test.pledged.by_site.#{r['siteName']}.pledged" => r['value'].to_f
                }
                #client = GraphiteAPI.new( :graphite => @options[:graphiteUrl] )
                puts "#{r['siteName']} - date: #{t.to_datetime}"

                @gClient.metrics(metrs,t)
                sleep(@options[:sleep])
          }
        end
    end

  end

end
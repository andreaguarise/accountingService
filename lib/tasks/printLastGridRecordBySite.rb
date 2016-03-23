require 'nokogiri'
require 'open-uri'


class GrafanaDashboard
  def initialize(content)
    @content = content
  end
  
  def print
    puts '{
  "rows": [
    {
      "title": "Summary",
      "height": "70px",
      "editable": false,
      "collapse": false,
      "collapsable": true,
      "panels": [
        {
          "error": false,
          "span": 7,
          "editable": false,
          "type": "text",
          "mode": "markdown",
          "content": "' + @content[:statistics] + '"
      ,"style": {},
          "title": "Grid statistics"
        },
        {
          "error": false,
          "span": 5,
          "editable": false,
          "type": "text",
          "mode": "markdown",
          "content": "' + @content[:nav] + '"
      ,"style": {},
          "title": "Navigation"
        }
      ],
      "notice": false
    },
    {
      "title": "Statistics",
      "height": "800px",
      "editable": true,
      "collapse": false,
      "collapsable": true,
      "panels": [
        {
          "error": false,
          "span": 12,
          "editable": true,
          "type": "text",
          "mode": "markdown",
          "content": "' + @content[:content] + '"
      ,"style": {},
          "title": "End date of last record published, per site"
        }
      ],
      "notice": false
    }
  ],
  "services": {
    "filter": {
      "time": {
        "from": "now-30d",
        "to": "now"
      }
    }
  },
  "title": "Summary",
  "editable": "false",
  "style": "light",
  "panel_hints": "false",
  "loader": {
    "save_gist": false,
    "save_elasticsearch": true,
    "save_local": true,
    "save_default": false,
    "save_temp": false,
    "save_temp_ttl_enable": false,
    "save_temp_ttl": "30d",
    "load_gist": false,
    "load_elasticsearch": true,
    "load_elasticsearch_size": 20,
    "load_local": true,
    "hide": true
  },
  "tags": [],
  "timezone": "browser",
  "failover": false,
  "pulldowns": [
    {
      "type": "templating"
    },
    {
      "type": "annotations"
    },
    {
      "type": "filtering",
      "enable": false
    }
  ],
  "nav": [
    {
      "type": "timepicker",
      "collapse": false,
      "notice": false,
      "enable": true,
      "status": "Stable",
      "time_options": [
        "12h",
        "24h",
        "2d",
        "7d",
        "30d"
      ],
      "refresh_intervals": [
        "5m",
        "15m",
        "30m",
        "1h",
        "2h",
        "1d"
      ],
      "now": true
    }
  ],
  "refresh": false
}'
  end
end

class GocInfo
  def initialize(url)
    @url = url
  end
  
  def get(matchSites)
    recordHash = Hash.new
    doc = Nokogiri::HTML(open(@url))
    doc.xpath("/html/body/table/tr").each do |tr|
      key = tr.xpath("td[1]").text
      if ( matchSites.key?(key) )
        recordHash[key] = tr.xpath("td[4]").text
      end
    end
    recordHash
  end
end

s = Site.joins(:apel_ssm_records).includes(:apel_ssm_records).where(:enabled => true).group("sites.name").maximum(:endTime)
interval = 86400 #DEFAULT
if Rails.configuration.warningTimeInterval
  interval = Rails.configuration.warningTimeInterval
 end 
buffer = ""
faustSites = Hash.new
late = 0
now = Time.at(Time.now).to_i
buffer = "Last updated: #{Time.at(Time.now)}\\n\\n"
sorted = s.sort_by {|site,date| date}
sorted.each do |site,date|
  faustSites[site] = date
end
goc = GocInfo.new('http://goc-accounting.grid-support.ac.uk/apel/jobs2.html')
gocInfoH = goc.get(faustSites)
sorted.each do |site,date|
  siteName=site
  if now - date > interval
    site = "**#{site}**"
    late = late +1
  end 
  buffer += "* [#{site}](#{Rails.configuration.grafanaUrl}/#/dashboard/script/grid-base.js?siteName=#{siteName}) --> #{Time.at(date)}  --  (GOC last record: #{gocInfoH[siteName]})\\n"
end
statistics = Hash.new
statistics[:content] = buffer
statistics[:statistics] = "Total Site publishing: **#{s.count}**. Number of sites non publishing records in the last #{interval/3600} Hours: **#{late}**"
statistics[:nav] = "[Main dashboard](#{Rails.configuration.grafanaUrl}/#/dashboard/script/grid-base.js)"
dash = GrafanaDashboard.new(statistics)
dash.print

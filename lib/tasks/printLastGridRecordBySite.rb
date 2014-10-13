


class GrafanaDashboard
  def initialize(content)
    @content = content
  end
  
  def print
    puts '{
  "rows": [
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
  "editable": "true",
  "style": "light",
  "panel_hints": "true",
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

s = Site.joins(:apel_ssm_records).includes(:apel_ssm_records).group("sites.name").maximum(:endTime)
buffer = ""
now = Time.at(Time.now).to_i
buffer = "Last updated: #{Time.at(Time.now)}\\n\\n"
sorted = s.sort_by {|site,date| date}
sorted.each do |site,date|
  if now - date > 129600
    site = "**#{site}**"
  end 
  buffer += "* #{site} --> #{Time.at(date)}\\n"
end
statistics = Hash.new
statistics[:content] = buffer
statistics[:countSites] = s.count
dash = GrafanaDashboard.new(statistics)
dash.print
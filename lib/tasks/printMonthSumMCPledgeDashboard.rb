
class GrafanaDashboard
  def initialize(content)
    @content = content 
  end
  # ten days 
  #\'target\': "alias(summarize(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site.' + site.name + '.by_vo.*.wall_H_KSi2k),\'1d\',\'sum\'),0.04167),\'10d\',\'avg\'),\'10 days average\')"
  def print
    rowBuffer = ""
    @content.each_slice(3) do |slice|
      rowBuffer += "\n"
      rowBuffer += 'dashboard.rows.push({
    title: \'Row\',
    height: \'250px\',
    editable: dashboardEditable,
    collapsable: false,
    panels: ['
    slice.each do |site|
    rowBuffer += '
      {
        title: \''+ site.name + '\',
        type: \'graphite\',
        span: 4,
        fill: 1,
        linewidth: 1,
        steppedLine: true,
        nullPointMode: \'null as zero\',
        legend: {
          show: true,
          values: true,
          current: true,
          avg: true,
          total: true,
          alignAsTable: true
        },
        targets: [
          {
            \'target\': "alias(summarize(sumSeries(scale(faust_pledge.by_site.' + site.name + '.by_vo.$vo.specInt2k,0.00274)), \'$binning\', \'sum\', true),\'pledge [Ksi2k][days] in $binning\')"
          },
          {
            \'target\': "aliasByNode(summarize(scale(summarize(sumSeriesWithWildcards(faust.cpu_grid_norm_records.by_site.' + site.name + '.by_vo.$vo.$wallMetric,5),\'1d\',\'sum\'),0.04167),\'$binning\',\'sum\'),5)"
          },
          {
            \'target\': lhcGraphPre + "' + site.name + '" + lhcGraphPost
          }
          
        ],
        seriesOverrides: [
        {
          alias: "/pledge/",
          stack: false
        },
        {
          alias: "/wall/",
          stack: false
        },
        {
          alias: "/pledge/",
          fill: 0,
          linewidth: 3
        }
        ],
        leftYAxisLabel: "[Ksi2k][days]",
        stack: true
      },'
    end  
    rowBuffer += ']
  });'
  rowBuffer += "\n"
    end
    puts '/* global _ */

// accessable variables in this scope
var window, document, ARGS, $, jQuery, moment, kbn;

// Setup some variables
var dashboard, timspan;

// All url parameters are available via the ARGS object
var ARGS;

// Set a default timespan if one isn\'t specified
timspan = \'90d\';

// Intialize a skeleton with nothing but a rows array and service object
dashboard = {
  rows : [],
  services : {}
};
showLegend = true;
showValues = true;
if ( ARGS.showValues == "false" ) {
  showValues = false;
}
metric= "wall_Day_KSi2k";
measure = "[days]*[Ksi2k]";
format = ["short","short"];
title = "pledge"

interactive = true;
if ( ARGS.interactive == "false" ) {
  interactive = false;
}



lhcGraphPre = "substr(sumSeriesWithWildcards(summarize(scale(faust.cpu_grid_norm_records.by_site.";
lhcGraphPost = ".by_lhc_vo.$vo.$wallMetric,0.04167),\'$binning\',\'sum\'),5), -3, 6)";
if ( ARGS.lhcStacked == "true" ) {
    lhcGraphPre = "substr(sumSeriesWithWildcards(summarize(scale(faust.cpu_grid_norm_records.by_site.";
    lhcGraphPost = ".by_lhc_vo.$vo.$wallMetric,0.04167),\'$binning\',\'sum\'),5), -3, 6)";
}


// Set a title
dashboard.title = \'Grid dashboard\';
dashboard.sharedCrosshair = \'true\';
dashboard.editable = \'false\';
dashboard.style= \'light\';
dashboard.panel_hints= \'false\';
dashboard.loader= {
    "save_gist": false,
    "save_elasticsearch": false,
    "save_local": false,
    "save_default": false,
    "save_temp": false,
    "save_temp_ttl_enable": false,
    "save_temp_ttl": "30d",
    "load_gist": false,
    "load_elasticsearch": false,
    "load_elasticsearch_size": 20,
    "load_local": false,
    "hide": true
  };
  
dashboard.nav = [
  {
    "type": "timepicker",
      "collapse": false,
      "notice": false,
      "enable": true,
      "status": "Stable",
      "time_options": [
        "10d",
        "30d",
        "60d",
        "90d",
        "180d",
        "365d"
      ],
      "refresh_intervals": [
        "15m",
        "30m",
        "1h",
        "2h",
        "1d"
      ],
      "now": true
  }
]

dashboard.services.filter = {
  time: {
    from: "now-" + (ARGS.from || timspan),
    to: "now"
  }
};

dashboard.pulldowns= [
        {
                "type": "filtering",
                "enable": true
        }
];

dashboard.services.filter = {
  time: {
    from: "now-" + (ARGS.from || timspan),
    to: "now"
  },
  list: [
   
    {
        "type": "query",
        "name": "vo",
        "active": true,
        "query": "faust.cpu_grid_norm_records.by_site.*.by_lhc_vo.*",
        "includeAll": true,
        "refresh": true,
        "allFormat": "wildcard",
        "current" : {
                "text": "all",
                "value": "*"
        }
    },
    {
        "type": "custom",
        "datasource": null,
        "refresh_on_load": false,
        "name": "binning",
        "options": [
          {
            "text": "1d",
            "value": "1d"
          },
          {
            "text": "7d",
            "value": "7d"
          },
          {
            "text": "30d",
            "value": "30d"
          },
          {
            "text": "90d",
            "value": "90d"
          },
          {
            "text": "180d",
            "value": "180d"
          },
          {
            "text": "365d",
            "value": "365d"
          },
        ],
        "includeAll": false,
        "allFormat": "glob",
        "query": "1d,7d,30d,90d,180d,365d",
        "current": {
          "text": "30d",
          "value": "30d"
        }
      },
      {
        "type": "query",
        "datasource": null,
        "refresh_on_load": false,
        "name": "wallMetric",
        "options": [
          {
            "text": "all",
            "value": "{mcwall_H_KSi2k,wall_H_KSi2k}"
          },
          {
            "text": "mcwall_H_KSi2k",
            "value": "mcwall_H_KSi2k"
          },
          {
            "text": "wall_H_KSi2k",
            "value": "wall_H_KSi2k"
          }
        ],
        "includeAll": true,
        "allFormat": "glob",
        "query": "faust.cpu_grid_norm_records.by_site.*.by_vo.*.*",
        "current": {
          "text": "All",
          "value": "{mcwall_H_KSi2k,wall_H_KSi2k}"
        },
        "regex": "/wall_/"
      }
  ]

};


dashboard.title = "Site pledges";
if(!_.isUndefined(ARGS.siteName) & ARGS.siteName != "*" ) {
  siteName = ARGS.siteName;
  dashboard.title = siteName;
}
else
{
        siteName = "*";
}

voName="*"
if(!_.isUndefined(ARGS.voName) & ARGS.voName != "*" ) {
  voName = ARGS.voName;
}

if( ARGS.editable == "true") {
  dashboardEditable = true;
  dashboard.editable = \'true\';
  dashboard.panel_hints= \'true\';
  dashboard.loader= {
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
  };
} else
{
  dashboardEditable = false;
}

navigationLink = \'<a href="./#/dashboard/script/grid-base.js?siteName=*">Grid Dashboard</a> - \' + 
          \'<a href="./#/dashboard/script/pledge_sum.js?lhcStacked=true" onClick="setTimeout(location.reload.bind(location), 1)">Pledge-sum LHC stack</a>\'
if ( ARGS.lhcStacked == "true" ) {
  navigationLink = \'<a href="./#/dashboard/script/grid-base.js?siteName=*">Grid Dashboard</a> - \' + 
          \'<a href="./#/dashboard/script/pledge_sum.js" onClick="setTimeout(location.reload.bind(location), 1)">Pledge-sum LHC aggregate</a>\'
}


if ( interactive == true ){
    dashboard.rows.push({
      title: \'Metrics\',
      height: \'14px\',
      editable: dashboardEditable,
      collapsable: false,
      panels: [
        {
          title: \'Nav\',
          type: \'text\',
          span: 4,
          mode: \'html\',
          content: navigationLink
        },
        {
          title: \'Note\',
          type: \'text\',
          span: 8,
          mode: \'html\',
          content: \'mcwall_*:  Normalised wall times using correction for multi processor jobs.\n\n wall_*: Normalised wall times\',
        },
      ]
   });
  }' + rowBuffer + '

  

return dashboard;'
  end
end

s = Site.joins(:grid_pledges).includes(:grid_pledges).all
faustSites = Hash.new
now = Time.at(Time.now).to_i
sorted = s.sort_by {|name| name}
dash = GrafanaDashboard.new(sorted)
dash.print


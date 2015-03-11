
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
            \'target\': "alias(sumSeries(scale(faust_pledge.by_site.' + site.name + '.by_vo.*.specInt2k,0.083)),\'pledge Ksi2k\')"
          },
          {
            \'target\': "alias(summarize(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site.' + site.name + '.by_vo.*.wall_H_KSi2k),\'1d\',\'sum\'),0.04167),\'30d\',\'sum\'),\'[Ksi2k][days] - all\')"
          },
          {
            \'target\': lhcGraphPre + "' + site.name + '" + lhcGraphPost
          }
          
        ],
        seriesOverrides: [
        {
          alias: "pledge Ksi2k",
          stack: false
        },
        {
          alias: "[Ksi2k][days] - all",
          stack: false
        },
        {
          alias: "pledge Ksi2k",
          fill: 0,
          linewidth: 3
        }
        ],
        leftYAxisLabel: "Ksi2k",
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



lhcGraphPre = "alias(summarize(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site.";
lhcGraphPost = ".by_lhc_vo.*.wall_H_KSi2k),\'1d\',\'sum\'),0.04167),\'30d\',\'sum\'),\'[Ksi2k][days]/ - lhc\')";
if ( ARGS.lhcStacked == "true" ) {
    lhcGraphPre = "aliasByNode(summarize(scale(summarize(faust.cpu_grid_norm_records.by_site.";
    lhcGraphPost = ".by_lhc_vo.*.wall_H_KSi2k,\'1d\',\'sum\'),0.04167),\'30d\',\'sum\'),5)";
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
/*
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
        "type": "terms",
        "name": "site",
        "active": true,
        "query": "faust.cpu_grid_norm_records.by_site.*",
        "includeAll": true
    }
  ]

};
*/

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
          span: 12,
          mode: \'html\',
          content: navigationLink
        }
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


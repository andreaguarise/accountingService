
class GrafanaDashboard
  def initialize(content)
    @content = content
  end
  
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
        linewidth: 2,
        targets: [
          {
            \'target\': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site.' + site.name + '.by_vo." + voName + ".wall_H_KSi2k),\'1d\',\'sum\'),6)"
          },
          {
            \'target\': "alias(scale(faust_pledge.by_site.'+ site.name + '.specInt2k,0.024),\'pledge ksi2k*H/day\')"
          }
        ],
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
metric= "wall_H_KSi2k";
measure = "hours*ksi2k";
format = ["short","short"];
title = "pledge"

interactive = true;
if ( ARGS.interactive == "false" ) {
  interactive = false;
}

// Set a title
dashboard.title = \'Grid dashboard\';
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
          content: \'<a href="./#/dashboard/script/grid-base.js?siteName=*\'
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

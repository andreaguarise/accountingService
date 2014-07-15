/* global _ */

/*
 * Complex scripted dashboard
 * This script generates a dashboard object that Grafana can load. It also takes a number of user
 * supplied URL parameters (int ARGS variable)
 *
 * Return a dashboard object, or a function
 *
 * For async scripts, return a function, this function must take a single callback function as argument,
 * call this callback function with the dashboard object (look at scripted_async.js for an example)
 */



// accessable variables in this scope
var window, document, ARGS, $, jQuery, moment, kbn;

// Setup some variables
var dashboard, timspan;

// All url parameters are available via the ARGS object
var ARGS;

// Set a default timespan if one isn't specified
timspan = '30d';

// Intialize a skeleton with nothing but a rows array and service object
dashboard = {
  rows : [],
  services : {}
};

// Set a title
dashboard.title = 'Sites dashboard';
dashboard.editable = 'false';
dashboard.style= 'light';
dashboard.panel_hints= 'false';
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

dashboard.title = "ALL sites";
if(!_.isUndefined(ARGS.siteName) & ARGS.siteName != "*" ) {
  siteName = ARGS.siteName;
  dashboard.title = siteName;
}
else
{
        siteName = "*";
}


if( ARGS.editable == "true") {
  dashboardEditable = true;
  dashboard.editable = 'true';
  dashboard.panel_hints= 'true';
  dashboard.loader= {
    "save_gist": true,
    "save_elasticsearch": true,
    "save_local": true,
    "save_default": false,
    "save_temp": false,
    "save_temp_ttl_enable": false,
    "save_temp_ttl": "30d",
    "load_gist": true,
    "load_elasticsearch": true,
    "load_elasticsearch_size": 20,
    "load_local": true,
    "hide": true
  };
} else
{
	dashboardEditable = false;
}


  dashboard.rows.push({
    title: 'GridStats',
    height: '300px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid - completed jobs',
        type: 'graphite',
        span: 6,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site."+ siteName +".all_vo.count),'1d','sum'),5)"
          }
        ],
      },
      {
        title: 'Grid - cpu/wall time',
        type: 'graphite',
        span: 6,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.cpuDuration),'1d','sum'),5)"
          },
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.wallDuration),'1d','sum'),5)"
          }
        ],
      }
    ]
  });

  dashboard.rows.push({
    title: 'GridStats',
    height: '250px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid Executed jobs - per VO',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*.count,'1d','sum'),3),4)"
          }
        ],
      },
      {
        title: 'Grid Executed jobs - per Site',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*.count,'1d','sum'),5),3)"
          }
        ],
      },
      {
        title: 'Normalized cputime and reported benchmark',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.cpu_H_KSi2k),'1d','sum'),5)"
          },
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.si2k),'1d','avg'),5)"
          }
        ],
      }
    ]
  });

return dashboard;


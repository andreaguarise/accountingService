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
showLegend = true;
showValues = true;
if ( ARGS.showValues == "false" ) {
	showValues = false;
}

// Set a title
dashboard.title = 'Cloud sites dashboard';
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
        "query": "faust.cpu_cloud_records.by_site.*",
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
    title: 'CloudStats',
    height: '200px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'Cloud instantiated VM and CPUs (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
      {
        title: 'CpuDuration and WallDuration',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'CpuDuration and WallDuration (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
    ]
  });

  if(_.isUndefined(ARGS.siteName)) {
  	dashboard.rows.push({
    title: 'CloudStats',
    height: '170px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Cloud instantiated VM by site',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'),7),8),3)"
          },
        ],
      },
      {
        title: 'Cloud instantiated VM and CPUs (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
      {
        title: 'CpuDuration and WallDuration',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'CpuDuration and WallDuration (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
    ]
  });
  dashboard.rows.push({
    title: 'CloudStats',
    height: '190px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'Cloud instantiated VM and CPUs (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
      {
        title: 'CpuDuration and WallDuration',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'CpuDuration and WallDuration (variation)',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "duration",
        y_formats: ["s","short"],
        targets: [
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuDuration,'1d','avg'))),10)"
          },
          {
            'target': "aliasByNode(derivative(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.wallDuration,'1d','avg'))),10)"
          }
        ],
        steppedLine: true,
      },
    ]
  });
  
  }

  dashboard.rows.push({
    title: 'CloudStats',
    height: '220px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Network traffic',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "Network usage",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkInbound,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkOutbound,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'Memory occupation',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "Memory",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg')),10)"
          }
        ],
      },
      {
        title: 'Disk occupation',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "storage",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.disk,'1d','avg')),10)"
          }
        ],
      }
    ]
  });
  
  if(_.isUndefined(ARGS.siteName)) {
  	dashboard.rows.push({
    title: 'CloudStats',
    height: '220px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Network inbound traffic by site',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "Network usage",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkInbound,'1d','avg'),7),8),3)"
          }
        ],
      },
      {
        title: 'Network outbound traffic by site',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "Network usage",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkOutbound,'1d','avg'),7),8),3)"
          }
        ],
      },
      {
        title: 'Memory occupation by site',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "Memory",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg'),7),8),3)"
          }
        ],
      },
      {
        title: 'Disk occupation by site',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: "storage",
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.disk,'1d','avg'),7),8),3)"
          }
        ],
      }
    ]
  });
  }
  
  if(!_.isUndefined(ARGS.siteName)) {
	dashboard.rows.push({
    title: 'GroupsCloudStats',
    height: '210px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'CPU allocated per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg'),9),7)"
          }
        ],
      },
      {
        title: 'VM allocated per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'),9),7)"
          }
        ],
      },
      {
        title: 'Network inbound traffic per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkInbound,'1d','avg'),9),7)"
          }
        ],
      },
      {
        title: 'Network outbound traffic per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkOutbound,'1d','avg'),9),7)"
          }
        ],
      },
      {
        title: 'memory allocated per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg'),9),7)"
          }
        ],
      },
      {
        title: 'disk allocated per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.disk,'1d','avg'),9),7)"
          }
        ],
      }
    ]
  	});
  	dashboard.rows.push({
    title: 'UsersCloudStats',
    height: '210px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'CPU allocated per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg'),7),8)"
          }
        ],
      },
      {
        title: 'VM allocated per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        leftYAxisLabel: "count",
        y_formats: ["short","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg'),7),8)"
          }
        ],
      },
      {
        title: 'Network inbound traffic per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkInbound,'1d','avg'),7),8)"
          }
        ],
      },
      {
        title: 'Network outbound traffic per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkOutbound,'1d','avg'),7),8)"
          }
        ],
      },
      {
        title: 'Memory allocated per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg'),7),8)"
          }
        ],
      },
      {
        title: 'Disk allocated per user',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 1,
        y_formats: ["bytes","short"],
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.disk,'1d','avg'),7),8)"
          }
        ],
      }
    ]
  	});
  }	

return dashboard;


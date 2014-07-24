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

// accessible variables in this scope
var window, document, ARGS, $, jQuery, moment, kbn;

// Setup some variables
var dashboard, timspan;

// All url parameters are available via the ARGS object
var ARGS;

// Set a default timespan if one isn't specified
timspan = '30d';
defaultHeigth='180px';

// Initialize a skeleton with nothing but a rows array and service object
dashboard = {
  rows : [],
  services : {}
};
showValues = true;
if ( ARGS.showValues == "false" ) {
	showValues = false;
}
interactive = true;
if ( ARGS.interactive == "false" ) {
	interactive = false;
}
cloud = true;
if ( ARGS.cloud == "false" ) {
	cloud = false;
}
grid = true;
if ( ARGS.grid == "false" ) {
	grid = false;
}
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

if(!_.isUndefined(ARGS.siteName)) {
  siteName = ARGS.siteName;
  dashboard.title = siteName;
}else
{
        siteName = "*";
        dashboard.title = "ALL sites";
}

if(!_.isUndefined(ARGS.name)) {
  seriesName = ARGS.name;
}

if( ARGS.editable == "true") {
  dashboardEditable = true;
  dashboard.editable = 'true';
  dashboard.panel_hints= 'true';
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

if( cloud == true) {
  if ( interactive == true ){
  	dashboard.rows.push({
    	title: 'Cloud',
    	height: '16px',
    	editable: dashboardEditable,
    	collapsable: false,
    	panels: [
      	{
        	title: 'Cloud Report',
        	type: 'text',
        	span: 12,
        	mode: 'html',
        	content: '<a href="./#/dashboard/script/cloud-base.js?siteName=' + siteName + '">cloud dashboard</a>'
      	}
      ]
   });
  }

  dashboard.rows.push({
    title: 'CloudStats',
    height: defaultHeigth,
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'count',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
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
        title: 'CpuDuration and WallDuration',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'hours',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
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
        title: 'Network traffic',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'bytes',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
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
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'GB',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(scale(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg')),1048576),10)"
          }
        ],
      }
      
    ]
  });
  
  if(!_.isUndefined(ARGS.siteName)) {
	dashboard.rows.push({
    title: 'GroupsCloudStats',
    height: defaultHeigth,
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'CPU allocated per group',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'count',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,9),7)"
          }
        ],
      },
      {
        title: 'VM allocated per group',
        type: 'graphite',
        span: 3,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'count',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
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
        linewidth: 2,
        leftYAxisLabel: 'bytes',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkInbound,9),7)"
          }
        ],
      },
      {
        title: 'Network outbound traffic per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'bytes',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.networkOutbound,9),7)"
          }
        ],
      },
      {
        title: 'memory allocated per group',
        type: 'graphite',
        span: 2,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'GB',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(scale(sumSeriesWithWildcards(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,9),1048576),7)"
          }
        ],
      }
    ]
  	});
  }
}

if( grid == true) {
	if ( interactive == true ){
		dashboard.rows.push({
	    title: 'Grid',
    	height: '16px',
	    editable: dashboardEditable,
	    collapsable: false,
	    panels: [
   	   {
    	    title: 'Grid Report',
	        type: 'text',
	        span: 12,
    	    mode: 'html',
        	content: '<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '">grid dashboard</a>'
      	}
    	  ]
   		});
  	}
	dashboard.rows.push({
    title: 'GridStats',
    height: defaultHeigth,
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid - completed jobs',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'count',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site."+ siteName +".all_vo.count),'1d','sum'),5)"
          }
        ],
      },
      {
        title: 'Grid - cpu/wall time',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'hours',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.cpuDuration),'1d','sum'),5)"
          },
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.wallDuration),'1d','sum'),5)"
          }
        ],
      },
      {
        title: 'Normalized cputime and reported benchmark',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'Ksi2K*hours',
        legend: {
        	show: true,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
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
  if(!_.isUndefined(ARGS.siteName)) {
  	dashboard.rows.push({
    title: 'GridStats',
    height: defaultHeigth,
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
        title: 'cpuTime - per VO',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*.cpuDuration,'1d','sum'),3),4)"
          }
        ],
      },
      {
        title: 'wallTime - per VO',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*.wallDuration,'1d','sum'),3),4)"
          }
        ],
      }
      
    ]
  });
  }
}
  	
return dashboard;


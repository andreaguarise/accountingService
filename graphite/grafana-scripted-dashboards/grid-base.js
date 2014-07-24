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
metric= "count";
measure = "count";
if ( !_.isUndefined(ARGS.metric) ) {
	metric = ARGS.metric;
	if ( metric == "cpuDuration" | metric == "wallDuration")
	{
		measure = "hours";
	}
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


  dashboard.rows.push({
    title: 'First Row',
    height: '250px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid - completed jobs',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: measure,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site."+ siteName +".all_vo." + metric + "),'1d','sum'),5)"
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
        rightYAxisLabel: 'percentage',
        legend: {
        	show: showLegend,
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
          },
          {
          	'target': "alias(summarize(divideSeries(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName +".all_vo.cpuDuration),sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".all_vo.wallDuration)),'1d','avg'),'efficiency')"
          }
        ],
        aliasYAxis: {
        	"efficiency": 2
        }
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

  dashboard.rows.push({
    title: 'Row2',
    height: '150px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
       {
        title: 'Grid Executed jobs - per VO - highest ranking',
        type: 'graphite',
        span: 6,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: measure,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(highestAverage(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*." + metric + ",'1d','sum'),3),5),4)"
          }
        ],
      },
      {
        title: 'Grid Executed jobs - per Site - highest ranking',
        type: 'graphite',
        span: 6,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: measure,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(highestAverage(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*." + metric + ",'1d','sum'),5),5),3)"
          }
        ],
      }
    ]
  });
  
  dashboard.rows.push({
    title: 'Row3',
    height: '200px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid Executed jobs - per VO - all',
        type: 'graphite',
        span: 12,
        fill: 2,
        linewidth: 0,
        leftYAxisLabel: 'count',
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        lines: false,
        bars: true,
        stack: true,
        zerofill: true,
        nullPointMode: 'null as zero',
        targets: [
          {
            'target': "aliasByNode(sortByMaxima(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*."+ metric +",'1d','sum'),3)),4)"
          }
        ],
      }
    ]
  });
  
  dashboard.rows.push({
    title: 'GridStats',
    height: '200px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid Executed jobs - per Site - all',
        type: 'graphite',
        span: 12,
        fill: 2,
        linewidth: 0,
        leftYAxisLabel: measure,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        lines: false,
        bars: true,
        stack: true,
        zerofill: true,
        nullPointMode: 'null as zero',
        targets: [
          {
            'target': "aliasByNode(sortByMaxima(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo.*." + metric + ",'1d','sum'),5)),3)"
          }
        ],
      },
    ]
  });
  
  dashboard.rows.push({
    title: 'GridStatsPerVomsGroup',
    height: '200px',
    editable: dashboardEditable,
    collapsable: false,
    panels: [
      {
        title: 'Grid Executed jobs - per VOMS group',
        type: 'graphite',
        span: 6,
        fill: 1,
        leftYAxisLabel: measure,
        linewidth: 2,
        targets: [
          {
                'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records_voGroup_voRole.by_site." + siteName + ".by_vo.*.by_voGroup.*.by_voRole.*." + metric + ",'1d','sum'),3),4),7),5)"
          }
        ],
      },
      {
        title: 'Grid Executed jobs - per VOMS Role',
        type: 'graphite',
        span: 6,
        fill: 1,
        leftYAxisLabel: measure,
        linewidth: 2,
        targets: [
          {
                'target': "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records_voGroup_voRole.by_site." + siteName + ".by_vo.*.by_voGroup.*.by_voRole.*." + metric + ",'1d','sum'),3),4),5),6)"
          }
        ],
      }
    ]
  });


return dashboard;


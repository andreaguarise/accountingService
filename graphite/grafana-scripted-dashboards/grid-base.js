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
scale = 1;
format = ["short","short"];
title = "completed jobs";
if ( !_.isUndefined(ARGS.metric) ) {
	metric = ARGS.metric;
	if ( metric == "cpuDuration" | metric == "wallDuration")
	{
		measure = "duration";
		title = metric;
		format = ["s","short"];
	}
	if ( metric == "cpu_H_KSi2k" )
	{
		measure = "ksi2k*day";
		title = metric;
		scale = "0.04167";
	}
	if ( metric == "wall_H_KSi2k" )
	{
		measure = "ksi2k*day";
		title = metric;
		scale = "0.04167";
	}
	if ( metric == "memoryReal" | metric == "memoryVirtual")
	{
		measure = "memory";
		title = metric;
		format = ["bytes","short"];
	}
	if ( metric == "efficiency" )
	{
		measure = "percentage";
		title = metric;
	}
}
interactive = true;
if ( ARGS.interactive == "false" ) {
	interactive = false;
}

// Set a title
dashboard.title = 'Grid dashboard';
dashboard.sharedCrosshair = 'true';
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
];


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

if(!_.isUndefined(ARGS.siteName) & ARGS.siteName != "*" ) {
  siteText = ARGS.siteName;
  siteValue = ARGS.siteName;
}
else
{
        siteText = "All";
        siteValue = "*";
}

if(!_.isUndefined(ARGS.voName) & ARGS.voName != "*" ) {
  voText = ARGS.voName;
  voValue = ARGS.voName;
}
else
{
        voText = "All";
        voValue = "*";
}

dashboard.services.filter = {
  time: {
    from: "now-" + (ARGS.from || timspan),
    to: "now"
  },
  list: [
    {
        "type": "query",
        "name": "site",
        "active": true,
        "query": "faust.cpu_grid_norm_records.by_site.*",
        "includeAll": true,
        "refresh": true,
        "allFormat": "wildcard",
        "current" : {
                "text": siteText,
                "value": siteValue
        }
    },
    {
        "type": "query",
        "name": "vo",
        "active": true,
        "query": "faust.cpu_grid_norm_records.by_site.$site.by_vo.*",
        "includeAll": true,
        "refresh": true,
        "allFormat": "wildcard",
        "current" : {
                "text": voText,
                "value": voValue
        }
    },
    {
        "type": "query",
        "datasource": null,
        "refresh_on_load": false,
        "name": "type",
        "options": [
          {
            "text": "All",
            "value": "*"
          },
          {
            "text": "grid",
            "value": "grid"
          },
          {
            "text": "local",
            "value": "local"
          }
        ],
        "includeAll": true,
        "allFormat": "wildcard",
        "query": "faust.cpu_grid_norm_records.by_site.*.by_vo.*.by_type.*",
        "current": {
          "text": "All",
          "value": "*"
        }
     }
  ]

};

dashboard.title = "Grid dashboard";
if(!_.isUndefined(ARGS.siteName) & ARGS.siteName != "*" ) {
  siteName = ARGS.siteName;
  dashboard.title = siteName;
}
else
{
        siteName = "$site";
}
siteName = "$site";

voName="$vo";
if(!_.isUndefined(ARGS.voName) & ARGS.voName != "*" ) {
  voName = ARGS.voName;
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

autoReload = 'onClick="setTimeout(location.reload.bind(location), 1)"';

if ( interactive == true ){
  	dashboard.rows.push({
    	title: 'Metrics',
    	height: '14px',
    	editable: dashboardEditable,
    	collapsable: false,
    	panels: [
      	{
        	title: 'Available metrics',
        	type: 'text',
        	span: 12,
        	mode: 'html',
        	content: '<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=count" ' + autoReload + ' >Record count</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=cpuDuration" ' + autoReload + ' >cpuDuration</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=wallDuration" ' + autoReload + ' >wallDuration</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=cpu_H_KSi2k" ' + autoReload + ' >Normalised Cpu Duration</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=wall_H_KSi2k" ' + autoReload + ' >Normalised Wall Duration</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=memoryReal" ' + autoReload + ' >MemoryReal</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=memoryVirtual" ' + autoReload + ' >MemoryVirtual</a> - ' +
        		'<a href="./#/dashboard/script/grid-base.js?siteName=' + siteName + '&metric=efficiency" ' + autoReload + ' >Efficiency</a> - ' +
        		'<a href="./#/dashboard/script/pledge_sum.js">Pledged</a> - ' +
        		'<a href="./#/dashboard/file/report.json">Publishing status</a>'
      	}
      ]
   });
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
        linewidth: 1,
        leftYAxisLabel: measure,
        y_formats: format,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: false,
        	avg: true,  	
        },
        targets: [
          {
            'target': "alias(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.*." + metric + "),'1d','sum')," + scale + "),'grid+local')"
          },
          {
            'target': "aliasByNode(scale(sortByMinima(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.*." + metric + ",'1d','sum'), 3), 4))," + scale + "),5)"
          }   
        ],
        seriesOverrides: [
            {
              alias: "grid+local",
              linewidth: 3,
              fill: 0
            }
          ],
      },
      {
        title: 'Grid - cpu/wall time - $type',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        leftYAxisLabel: 'duration - days',
        y_formats: ["s","short"],
        rightYAxisLabel: 'percentage',
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: false,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".by_vo." + voName + ".by_type.$type.cpuDuration),'1d','sum')," + scale + "),8)"
          },
          {
            'target': "aliasByNode(scale(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".by_vo." + voName + ".by_type.$type.wallDuration),'1d','sum')," + scale + "),8)"
          },
          {
          	'target': "alias(summarize(divideSeries(#A,#B),'1d','avg'),'efficiency')"
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
            'target': "aliasByNode(summarize(sumSeries(faust.cpu_grid_norm_records.by_site." + siteName + ".by_vo." + voName + ".by_type.$type.cpu_H_KSi2k),'1d','sum'),8)"
          },
          {
            'target': "aliasByNode(sumSeries(averageSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo."+ voName +".by_type.$type.si2k,'1d','avg'),5)),8)"
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
        y_formats: format,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: false,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(scale(highestAverage(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.$type." + metric + ",'1d','sum'),3),5)," + scale + "),4)"
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
        y_formats: format,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: true,
        	avg: true,  	
        },
        targets: [
          {
            'target': "aliasByNode(scale(highestAverage(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.$type." + metric + ",'1d','sum'),5),5)," + scale + "),3)"
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
        leftYAxisLabel: measure,
        y_formats: format,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: false,
        	avg: true,  	
        },
        lines: false,
        bars: true,
        stack: true,
        zerofill: true,
        nullPointMode: 'null as zero',
        targets: [
          {
            'target': "aliasByNode(scale(sortByMaxima(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.$type."+ metric +",'1d','sum'),3))," + scale + "),4,6)"
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
        title: 'Grid Executed jobs - per Site - $site',
        type: 'graphite',
        span: 12,
        fill: 2,
        linewidth: 0,
        leftYAxisLabel: measure,
        y_formats: format,
        legend: {
        	show: showLegend,
        	values: showValues,
        	current: false,
        	avg: true,  	
        },
        lines: false,
        bars: true,
        stack: true,
        zerofill: true,
        nullPointMode: 'null as zero',
        targets: [
          {
            'target': "aliasByNode(scale(sortByMaxima(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records.by_site."+ siteName +".by_vo." + voName + ".by_type.$type." + metric + ",'1d','sum'),5))," + scale + "),3,6)"
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
        y_formats: format,
        linewidth: 2,
        targets: [
          {
                'target': "aliasByNode(scale(sumSeriesWithWildcards(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records_voGroup_voRole.by_site." + siteName + ".by_vo." + voName + ".by_voGroup.*.by_voRole.*." + metric + ",'1d','sum'),3),4),7)," + scale + "),5)"
          }
        ],
      },
      {
        title: 'Grid Executed jobs - per VOMS Role',
        type: 'graphite',
        span: 6,
        fill: 1,
        leftYAxisLabel: measure,
        y_formats: format,
        linewidth: 2,
        targets: [
          {
                'target': "aliasByNode(scale(sumSeriesWithWildcards(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust.cpu_grid_norm_records_voGroup_voRole.by_site." + siteName + ".by_vo." + voName + ".by_voGroup.*.by_voRole.*." + metric + ",'1d','sum'),3),4),5)," + scale + "),6)"
          }
        ],
      }
    ]
  });


return dashboard;



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

// Intialize a skeleton with nothing but a rows array and service object
dashboard = {
  rows : [],
  services : {}
};

// Set a title
dashboard.title = 'Sites dashboard';
dashboard.services.filter = {
  time: {
    from: "now-" + (ARGS.from || timspan),
    to: "now"
  }
};

if(!_.isUndefined(ARGS.siteName)) {
  siteName = ARGS.siteName;
  dashboard.title = siteName;
} else
{
	siteName = "*";
}

if(!_.isUndefined(ARGS.name)) {
  seriesName = ARGS.name;
}


  dashboard.rows.push({
    title: 'CloudStats',
    height: '300px',
    panels: [
      {
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 12,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.vmCount,'1d','avg')),10)"
          },
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.cpuCount,'1d','avg')),10)"
          }
        ],
      }
    ]
  });

dashboard.rows.push({
    title: 'CloudStats',
    height: '250px',
    panels: [
      {
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
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
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
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
        title: 'Cloud instantiated VM and CPUs',
        type: 'graphite',
        span: 4,
        fill: 1,
        linewidth: 2,
        targets: [
          {
            'target': "aliasByNode(sumSeries(summarize(faust.cpu_cloud_records.by_site." + siteName + ".by_status.RUNNING.by_group.*.by_user.*.memory,'1d','avg')),10)"
          }
        ],
      }
    ]
  });



return dashboard;


{
  "id": null,
  "title": "cloud-torino",
  "originalTitle": "cloud-torino",
  "tags": [],
  "style": "dark",
  "timezone": "browser",
  "editable": true,
  "hideControls": false,
  "sharedCrosshair": true,
  "rows": [
    {
      "title": "New row",
      "height": "25px",
      "editable": true,
      "collapse": false,
      "panels": [
        {
          "title": "",
          "error": false,
          "span": 12,
          "editable": true,
          "type": "text",
          "id": 24,
          "mode": "html",
          "content": "<a href = \"http://dgas-broker.to.infn.it:8081/zabbix\">Go to Zabbix panel</a>",
          "style": {},
          "links": []
        }
      ]
    },
    {
      "title": "All sites 1",
      "height": "200px",
      "editable": false,
      "collapsable": false,
      "panels": [
        {
          "title": "Cloud instantiated VM and CPUs",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "count",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(summarize(sumSeries(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.vmCount), '$binning', 'avg', true), 10)",
              "hide": false
            },
            {
              "target": "aliasByNode(summarize(sumSeries(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuCount), '$binning', 'avg', false), 10)",
              "hide": false
            },
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.vmCount, '$binning', 'avg')), 10)",
              "hide": true
            },
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuCount, '$binning', 'avg')), 10)",
              "hide": true
            }
          ],
          "id": 1,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": []
        },
        {
          "title": "Memory occupation",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "Memory",
          "y_formats": [
            "bytes",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.memory, '$binning', 'avg')), 10)"
            }
          ],
          "id": 14,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": []
        },
        {
          "title": "CpuDuration and WallDuration",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "duration",
          "y_formats": [
            "s",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeries(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuDuration), 10)",
              "hide": false
            },
            {
              "target": "aliasByNode(sumSeries(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.wallDuration), 10)",
              "hide": false
            }
          ],
          "id": 3,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": true,
            "min": false,
            "max": false,
            "current": true,
            "total": false,
            "avg": false
          },
          "nullPointMode": "null",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Network traffic",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "Network usage",
          "y_formats": [
            "bytes",
            "bytes"
          ],
          "targets": [
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.networkInbound, '$binning', 'avg'))), 10)"
            },
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.networkOutbound, '$binning', 'avg'))), 10)"
            }
          ],
          "id": 20,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [
            {
              "alias": "networkOutbound",
              "yaxis": 2
            }
          ]
        }
      ],
      "collapse": false
    },
    {
      "title": "New row",
      "height": "150px",
      "editable": true,
      "collapse": false,
      "panels": [
        {
          "title": "Cpu Utilization (%)",
          "type": "graph",
          "span": 12,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "percentage",
          "y_formats": [
            "percent",
            "short"
          ],
          "targets": [
            {
              "target": "sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuFractionMultCpu, '$binning', 'avg'))",
              "hide": true
            },
            {
              "target": "sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuCount, '$binning', 'avg'))",
              "hide": true
            },
            {
              "target": "alias(scale(divideSeries(#A, #B), 100), 'cpu fraction binning: $binning')",
              "hide": false
            },
            {
              "target": "alias(summarize(scale(divideSeries(#A, #B), 100), '7d', 'avg'), 'cpu fraction 7d mean')",
              "hide": false
            }
          ],
          "steppedLine": true,
          "id": 4,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": 30,
            "threshold2": 70,
            "threshold1Color": "rgba(216, 200, 27, 0.17)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [
            {
              "alias": "cpu fraction 7d mean",
              "steppedLine": false,
              "linewidth": 1
            },
            {}
          ],
          "links": []
        }
      ]
    },
    {
      "title": "New row",
      "height": "200px",
      "editable": true,
      "collapse": false,
      "panels": [
        {
          "title": "Cpu Utilization - user breakdown(%)",
          "type": "graph",
          "span": 12,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "percentage",
          "y_formats": [
            "percent",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(scale(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuFraction, '$binning', 'avg'), 100), 9)",
              "hide": false
            }
          ],
          "steppedLine": true,
          "id": 18,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": 100,
            "rightMax": null,
            "leftMin": 0,
            "rightMin": null,
            "threshold1": 30,
            "threshold2": 70,
            "threshold1Color": "rgba(216, 200, 27, 0.15)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        }
      ]
    },
    {
      "title": "New row",
      "height": "200px",
      "editable": true,
      "collapse": false,
      "panels": [
        {
          "title": "Cloud instantiated CPUs fraction",
          "type": "graph",
          "span": 6,
          "fill": 2,
          "linewidth": 1,
          "leftYAxisLabel": "percentage",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sortByMinima(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.cpuCount, '$binning', 'avg')), 9)"
            }
          ],
          "id": 22,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": true,
          "percentage": true,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "individual",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Cloud instantiated memory fraction",
          "type": "graph",
          "span": 6,
          "fill": 2,
          "linewidth": 1,
          "leftYAxisLabel": "percentage",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sortByMinima(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*.memory, '$binning', 'avg')), 9)"
            }
          ],
          "id": 23,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": true,
          "percentage": true,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "individual",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        }
      ]
    },
    {
      "title": "New row",
      "height": "25px",
      "editable": true,
      "collapse": false,
      "panels": [
        {
          "title": "",
          "error": false,
          "span": 12,
          "editable": true,
          "type": "text",
          "id": 21,
          "mode": "text",
          "content": "User: $user",
          "style": {
            "font-size": "60pt"
          },
          "links": []
        }
      ]
    },
    {
      "title": "Per sites 1",
      "height": "170px",
      "editable": false,
      "collapsable": false,
      "panels": [
        {
          "title": "Cloud instantiated VM",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "count",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.vmCount, '$binning', 'avg'), 7), 8), 3)"
            }
          ],
          "id": 5,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Cloud instantiated VM (variation)",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "count",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(derivative(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.vmCount, '$binning', 'avg'), 7), 8)), 3)"
            }
          ],
          "steppedLine": true,
          "id": 6,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Integral CpuDuration",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "duration",
          "y_formats": [
            "s",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.cpuDuration, '$binning', 'avg')), 10)"
            }
          ],
          "id": 7,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": true,
            "min": false,
            "max": false,
            "current": true,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "CpuDuration (variation)",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "duration",
          "y_formats": [
            "s",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.cpuDuration, '$binning', 'avg'), 7), 8)), 3)"
            }
          ],
          "steppedLine": true,
          "id": 8,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        }
      ],
      "collapse": false
    },
    {
      "title": "Per site 2",
      "height": "170px",
      "editable": false,
      "collapsable": false,
      "panels": [
        {
          "title": "Cloud instantiated CPU",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "count",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.cpuCount, '$binning', 'avg'), 7), 8), 3)"
            }
          ],
          "id": 9,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Cloud instantiated CPU  (variation)",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "count",
          "y_formats": [
            "short",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(derivative(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.cpuCount, '$binning', 'avg'), 7), 8)), 3)"
            }
          ],
          "steppedLine": true,
          "id": 10,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Integral WallDuration",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "duration",
          "y_formats": [
            "s",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.wallDuration, '$binning', 'avg'), 7), 8), 8)"
            }
          ],
          "id": 11,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": true,
            "min": false,
            "max": false,
            "current": true,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "WallDuration (variation)",
          "type": "graph",
          "span": 3,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "duration",
          "y_formats": [
            "s",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeriesWithWildcards(sumSeriesWithWildcards(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.wallDuration, '$binning', 'avg'), 7), 8)), 3)"
            }
          ],
          "steppedLine": true,
          "id": 12,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        }
      ],
      "collapse": false
    },
    {
      "title": "CloudStats",
      "height": "200px",
      "editable": false,
      "collapsable": false,
      "panels": [
        {
          "title": "Cpu Utilization  (%) (binning: $binning)",
          "type": "graph",
          "span": 12,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "percentage",
          "y_formats": [
            "percent",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(summarize(scale(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.cpuFraction, 100), '$binning', 'avg', false), 9)",
              "hide": false
            },
            {
              "target": "alias(scale(divideSeries(#C, #B), 100), 'cpuUtilization')",
              "hide": true
            }
          ],
          "steppedLine": true,
          "id": 25,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": 30,
            "threshold2": 70,
            "threshold1Color": "rgba(216, 200, 27, 0.15)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": true,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": true
          },
          "nullPointMode": "connected",
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        }
      ],
      "collapse": false
    },
    {
      "title": "Per sites 3",
      "height": "200px",
      "editable": false,
      "collapsable": false,
      "panels": [
        {
          "title": "Disk occupation",
          "type": "graph",
          "span": 4,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "storage",
          "y_formats": [
            "bytes",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.disk, '$binning', 'avg')), 10)"
            }
          ],
          "id": 15,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [],
          "links": []
        },
        {
          "title": "Network traffic",
          "type": "graph",
          "span": 4,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "Network usage",
          "y_formats": [
            "bytes",
            "bytes"
          ],
          "targets": [
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.networkInbound, '$binning', 'avg'))), 10)"
            },
            {
              "target": "aliasByNode(nonNegativeDerivative(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.networkOutbound, '$binning', 'avg'))), 10)"
            }
          ],
          "id": 13,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": [
            {
              "alias": "networkOutbound",
              "yaxis": 2
            }
          ]
        },
        {
          "title": "Memory occupation",
          "type": "graph",
          "span": 4,
          "fill": 1,
          "linewidth": 2,
          "leftYAxisLabel": "Memory",
          "y_formats": [
            "bytes",
            "short"
          ],
          "targets": [
            {
              "target": "aliasByNode(sumSeries(summarize(faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.$user.memory, '$binning', 'avg')), 10)"
            }
          ],
          "id": 19,
          "datasource": null,
          "renderer": "flot",
          "x-axis": true,
          "y-axis": true,
          "grid": {
            "leftMax": null,
            "rightMax": null,
            "leftMin": null,
            "rightMin": null,
            "threshold1": null,
            "threshold2": null,
            "threshold1Color": "rgba(216, 200, 27, 0.27)",
            "threshold2Color": "rgba(234, 112, 112, 0.22)"
          },
          "lines": true,
          "points": false,
          "pointradius": 5,
          "bars": false,
          "stack": false,
          "percentage": false,
          "legend": {
            "show": true,
            "values": false,
            "min": false,
            "max": false,
            "current": false,
            "total": false,
            "avg": false
          },
          "nullPointMode": "connected",
          "steppedLine": false,
          "tooltip": {
            "value_type": "cumulative",
            "shared": false
          },
          "aliasColors": {},
          "seriesOverrides": []
        }
      ],
      "collapse": false
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
        "365d",
        "180d",
        "90d",
        "60d",
        "30d",
        "7d",
        "1d"
      ],
      "refresh_intervals": [
        "5s",
        "10s",
        "30s",
        "1m",
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
  "time": {
    "from": "now-30d",
    "to": "now"
  },
  "templating": {
    "list": [
      {
        "type": "query",
        "datasource": null,
        "refresh_on_load": false,
        "name": "user",
        "options": [
          {
            "text": "All",
            "value": "*"
          },
          {
            "text": "adegano",
            "value": "adegano"
          },
          {
            "text": "aguarise",
            "value": "aguarise"
          },
          {
            "text": "bagnasco",
            "value": "bagnasco"
          },
          {
            "text": "bes",
            "value": "bes"
          },
          {
            "text": "bubble",
            "value": "bubble"
          },
          {
            "text": "cms",
            "value": "cms"
          },
          {
            "text": "compass",
            "value": "compass"
          },
          {
            "text": "ebes",
            "value": "ebes"
          },
          {
            "text": "faust",
            "value": "faust"
          },
          {
            "text": "fermi",
            "value": "fermi"
          },
          {
            "text": "giunti",
            "value": "giunti"
          },
          {
            "text": "guarise",
            "value": "guarise"
          },
          {
            "text": "jlab12",
            "value": "jlab12"
          },
          {
            "text": "mcnp",
            "value": "mcnp"
          },
          {
            "text": "monitoring",
            "value": "monitoring"
          },
          {
            "text": "oneadmin",
            "value": "oneadmin"
          },
          {
            "text": "prooftaf",
            "value": "prooftaf"
          },
          {
            "text": "rdh",
            "value": "rdh"
          },
          {
            "text": "rsicc",
            "value": "rsicc"
          },
          {
            "text": "saletta",
            "value": "saletta"
          },
          {
            "text": "sfarm",
            "value": "sfarm"
          },
          {
            "text": "solido",
            "value": "solido"
          },
          {
            "text": "svallero",
            "value": "svallero"
          },
          {
            "text": "testuser",
            "value": "testuser"
          },
          {
            "text": "ufsd",
            "value": "ufsd"
          }
        ],
        "includeAll": true,
        "allFormat": "wildcard",
        "query": "faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.$status.by_group.*.by_user.*",
        "current": {
          "text": "All",
          "value": "*"
        },
        "refresh": true
      },
      {
        "type": "custom",
        "datasource": null,
        "refresh_on_load": false,
        "name": "binning",
        "options": [
          {
            "text": "15m",
            "value": "15m"
          },
          {
            "text": "1h",
            "value": "1h"
          },
          {
            "text": "6h",
            "value": "6h"
          },
          {
            "text": "1d",
            "value": "1d"
          },
          {
            "text": "7d",
            "value": "7d"
          }
        ],
        "includeAll": false,
        "allFormat": "glob",
        "query": "15m,1h,6h,1d,7d",
        "current": {
          "text": "6h",
          "value": "6h"
        }
      },
      {
        "type": "query",
        "datasource": null,
        "refresh_on_load": false,
        "name": "status",
        "options": [
          {
            "text": "BOOT",
            "value": "BOOT"
          },
          {
            "text": "BOOT_POWEROFF",
            "value": "BOOT_POWEROFF"
          },
          {
            "text": "BOOT_SUSPENDED",
            "value": "BOOT_SUSPENDED"
          },
          {
            "text": "CLEANUP",
            "value": "CLEANUP"
          },
          {
            "text": "EPILOG",
            "value": "EPILOG"
          },
          {
            "text": "EPILOG_STOP",
            "value": "EPILOG_STOP"
          },
          {
            "text": "FAILURE",
            "value": "FAILURE"
          },
          {
            "text": "HOTPLUG",
            "value": "HOTPLUG"
          },
          {
            "text": "LCMUNDEFINED1",
            "value": "LCMUNDEFINED1"
          },
          {
            "text": "LCMUNDEFINED4",
            "value": "LCMUNDEFINED4"
          },
          {
            "text": "PENDING",
            "value": "PENDING"
          },
          {
            "text": "PROLOG_MIGRATE",
            "value": "PROLOG_MIGRATE"
          },
          {
            "text": "RUNNING",
            "value": "RUNNING"
          },
          {
            "text": "SAVE_MIGRATE",
            "value": "SAVE_MIGRATE"
          },
          {
            "text": "SAVE_SUSPEND",
            "value": "SAVE_SUSPEND"
          },
          {
            "text": "SHUTDOWN",
            "value": "SHUTDOWN"
          },
          {
            "text": "SHUTDOWN_POWEROFF",
            "value": "SHUTDOWN_POWEROFF"
          },
          {
            "text": "UNKNOWN",
            "value": "UNKNOWN"
          },
          {
            "text": "by_group",
            "value": "by_group"
          },
          {
            "text": "completed",
            "value": "completed"
          },
          {
            "text": "one:",
            "value": "one:"
          },
          {
            "text": "one:HOTPLUG",
            "value": "one:HOTPLUG"
          },
          {
            "text": "one:LCMUNDEFINED1",
            "value": "one:LCMUNDEFINED1"
          },
          {
            "text": "one:LCMUNDEFINED4",
            "value": "one:LCMUNDEFINED4"
          },
          {
            "text": "one:SHUTDOWN_POWEROFF",
            "value": "one:SHUTDOWN_POWEROFF"
          },
          {
            "text": "one:UNKNOWN",
            "value": "one:UNKNOWN"
          }
        ],
        "includeAll": false,
        "allFormat": "glob",
        "query": "faust_cloud_live.cpu_cloud_records_live.by_site.*.by_status.*",
        "current": {
          "text": "RUNNING",
          "value": "RUNNING"
        },
        "refresh": true
      }
    ],
    "enable": true
  },
  "annotations": {
    "list": []
  },
  "refresh": false,
  "version": 6,
  "hideAllLegends": false
}
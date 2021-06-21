import 'package:flutter/material.dart';
import 'package:timetracker_mobile/mobile/graph/chart_data_set.dart';
import 'package:timetracker_mobile/mobile/graph/scaling_info.dart';
import 'package:timetracker_mobile/mobile/graph/hours_graph.dart';
import 'package:timetracker_mobile/shared/utils.dart';

import 'chart.dart';
import 'chart_background_painter.dart';
import 'chart_painter.dart';

class ChartData {
  ChartDataSet dataSet1 = ChartDataSet([
    7.0,
    7.2,
    7.3,
    7.0,
    6.5,
    6.8,
    7.1,
    6.8,
    7.0,
    7.0,
    7.0,
    7.1,
    6.8,
    6.8,
    7.0,
    7.0,
    7.0,
    7.1,
    7.1,
    7.2,
    7.2
  ]);
  ChartDataSet dataSet2 = ChartDataSet([
    2.0,
    2.2,
    4.3,
    1.0,
    6.5,
    6.8,
    7.1,
    6.8,
    7.0,
    7.0,
    7.0,
    7.1,
    6.8,
    6.8,
    7.0,
    7.0,
    7.0,
    7.1,
    7.1,
    7.2,
    7.2
  ]);
}

class GraphContent extends StatefulWidget {
  @override
  _GraphContentState createState() => _GraphContentState();
}

class _GraphContentState extends State<GraphContent>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Chart _chart;

  @override
  void initState() {
    var data = ChartData();
    _chart = Chart([data.dataSet1, data.dataSet2], '', '\$');
    _chart.domainStart = 0;
    _chart.domainEnd = 13;
    _chart.rangeStart = 0;
    _chart.rangeEnd = 8;
    _chart.selectedDataPoint = 4;
    _chart.addListener(() => setState(() {}));
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 12000),
        upperBound: _chart.maxDomain);

    _controller.addListener(() {
      final d = _controller.value - _chart.domainStart;
      if (d < 0) {
        _chart.domainStart += d;
        _chart.domainEnd += d;
      } else {
        _chart.domainEnd += d;
        _chart.domainStart += d;
      }
    });

    super.initState();
  }

  @override
  Widget build(context) {
    if (!ScalingInfo.initialized) {
      ScalingInfo.init(context);
    }

    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text("Work in progress"),
                        HoursGraph(chart: _chart),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

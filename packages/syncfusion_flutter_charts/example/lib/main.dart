import 'package:charts_example/trackball_behavior.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<LynusPoint> data = [
    LynusPoint(1661378400, 0),
    LynusPoint(1661378700, 0),
    LynusPoint(1661379000, 0),
    LynusPoint(1661379300, 0),
    LynusPoint(1661379600, 1),
    LynusPoint(1661379900, 0),
    LynusPoint(1661380200, 0),
    LynusPoint(1661380500, 0),
    LynusPoint(1661380800, 0),
    LynusPoint(1661381100, 0),
    LynusPoint(1661381400, 0),
    LynusPoint(1661381700, 0),
    LynusPoint(1661382000, 0),
    LynusPoint(1661382300, 0),
    LynusPoint(1661382600, 0),
    LynusPoint(1661382900, 0),
    LynusPoint(1661383200, 0),
    LynusPoint(1661383500, 1),
    LynusPoint(1661383800, 0),
    LynusPoint(1661384100, 0),
    LynusPoint(1661384400, 0),
    LynusPoint(1661384700, 0),
    LynusPoint(1661385000, 0),
    LynusPoint(1661385300, 0),
    LynusPoint(1661385600, 0),
    LynusPoint(1661385900, 0),
    LynusPoint(1661386200, 0),
    LynusPoint(1661386500, 0),
    LynusPoint(1661386800, 0),
    LynusPoint(1661387100, 0),
    LynusPoint(1661387400, 0),
    LynusPoint(1661387700, 0),
    LynusPoint(1661388000, 0),
    LynusPoint(1661388300, 0),
    LynusPoint(1661388600, 0),
    LynusPoint(1661388900, 0),
    LynusPoint(1661389200, 0),
    LynusPoint(1661389500, 0),
    LynusPoint(1661389800, 0),
    LynusPoint(1661390100, 0),
    LynusPoint(1661390400, 0),
    LynusPoint(1661390700, 0),
    LynusPoint(1661391000, 0),
    LynusPoint(1661391300, 0),
    LynusPoint(1661391600, 0),
    LynusPoint(1661391900, 0),
    LynusPoint(1661392200, 0),
    LynusPoint(1661392500, 0),
    LynusPoint(1661392800, 0),
    LynusPoint(1661393100, 0),
    LynusPoint(1661393400, 0),
    LynusPoint(1661393700, 0),
    LynusPoint(1661394000, 0),
    LynusPoint(1661394300, 0),
    LynusPoint(1661394600, 0),
    LynusPoint(1661394900, 0),
    LynusPoint(1661395200, 0),
    LynusPoint(1661395500, 0),
    LynusPoint(1661395800, 1),
    LynusPoint(1661396100, 0),
    LynusPoint(1661396400, 0),
    LynusPoint(1661396700, 0),
    LynusPoint(1661397000, 0),
    LynusPoint(1661397300, 0),
    LynusPoint(1661397600, 0),
    LynusPoint(1661397900, 0),
    LynusPoint(1661398200, 0),
    LynusPoint(1661398500, 0),
    LynusPoint(1661398800, 0),
    LynusPoint(1661399100, 0),
    LynusPoint(1661399400, 0),
    LynusPoint(1661399700, 0),
    LynusPoint(1661400000, 1),
    LynusPoint(1661400300, 0),
    LynusPoint(1661400600, 0),
    LynusPoint(1661400900, 0),
    LynusPoint(1661401200, 0),
    LynusPoint(1661401500, 0),
    LynusPoint(1661401800, 0),
    LynusPoint(1661402100, 0),
    LynusPoint(1661402400, 0),
    LynusPoint(1661402700, 0),
    LynusPoint(1661403000, 0),
    LynusPoint(1661403300, 1),
    LynusPoint(1661403600, 0),
    LynusPoint(1661403900, 0),
    LynusPoint(1661404200, 0),
    LynusPoint(1661404500, 0),
    LynusPoint(1661404800, 0),
    LynusPoint(1661405100, 0),
    LynusPoint(1661405400, 0),
    LynusPoint(1661405700, 0),
    LynusPoint(1661406000, 0),
    LynusPoint(1661406300, 1),
    LynusPoint(1661406600, 1),
    LynusPoint(1661406900, 0),
    LynusPoint(1661407200, 0),
    LynusPoint(1661407500, 0),
    LynusPoint(1661407800, 0),
    LynusPoint(1661408100, 0),
    LynusPoint(1661408400, 0),
    LynusPoint(1661408700, 0),
    LynusPoint(1661409000, 1),
    LynusPoint(1661409300, 0),
    LynusPoint(1661409600, 0),
    LynusPoint(1661409900, 0),
    LynusPoint(1661410200, 0),
    LynusPoint(1661410500, 0),
    LynusPoint(1661410800, 0),
    LynusPoint(1661411100, 0),
    LynusPoint(1661411400, 0),
    LynusPoint(1661411700, 0),
    LynusPoint(1661412000, 0),
    LynusPoint(1661412300, 0),
    LynusPoint(1661412600, 0),
    LynusPoint(1661412900, 0),
    LynusPoint(1661413200, 0),
    LynusPoint(1661413500, 0),
    LynusPoint(1661413800, 0),
    LynusPoint(1661414100, 0),
    LynusPoint(1661414400, 0),
    LynusPoint(1661414700, 0),
    LynusPoint(1661415000, 0),
    LynusPoint(1661415300, 0),
    LynusPoint(1661415600, 0),
    LynusPoint(1661415900, 0),
    LynusPoint(1661416200, 0),
    LynusPoint(1661416500, 0),
    LynusPoint(1661416800, 0),
    LynusPoint(1661417100, 0),
    LynusPoint(1661417400, 0),
    LynusPoint(1661417700, 0),
    LynusPoint(1661418000, 0),
    LynusPoint(1661418300, 0),
    LynusPoint(1661418600, 0),
    LynusPoint(1661418900, 0),
    LynusPoint(1661419200, 0),
    LynusPoint(1661419500, 0),
    LynusPoint(1661419800, 0),
    LynusPoint(1661420100, 0),
    LynusPoint(1661420400, 0),
    LynusPoint(1661420700, 0),
    LynusPoint(1661421000, 0),
    LynusPoint(1661421300, 0),
    LynusPoint(1661421600, 0),
    LynusPoint(1661421900, 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                desiredIntervals: 6,
                maximumLabels: 3,
                majorGridLines: const MajorGridLines(width: 0),
                minimum: DateTime.fromMillisecondsSinceEpoch(1661378400 * 1000),
                visibleMinimum:
                    DateTime.fromMillisecondsSinceEpoch(1661378400 * 1000),
                maximum: DateTime.fromMillisecondsSinceEpoch(1661464800 * 1000),
                visibleMaximum:
                    DateTime.fromMillisecondsSinceEpoch(1661464800 * 1000),
                labelIntersectAction: AxisLabelIntersectAction.rotate90,
              ),
              primaryYAxis: NumericAxis(name: "y0"),
              // Chart title
              title: ChartTitle(text: 'Title'),
              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              trackballBehavior: LynusTrackballBehavior(
                tooltipTimeFormat: "dd.MM.yyyy HH:mm",
              ),
              series: <ChartSeries<LynusPoint, DateTime>>[
                FastLineSeries<LynusPoint, DateTime>(
                  dataSource: data,
                  xValueMapper: (LynusPoint data, _) =>
                      DateTime.fromMillisecondsSinceEpoch(
                          data.x.toInt() * 1000),
                  yValueMapper: (LynusPoint sales, _) => sales.y,
                  name: 'Sales sales sales sales',
                  yAxisName: "y0",
                ),
              ]),
        ));
  }
}

/// A representation of a point in the chart data.
class LynusPoint {
  num x;
  num? y;

  LynusPoint(this.x, this.y);
}

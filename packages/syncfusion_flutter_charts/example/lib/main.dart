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
  List<_ChartData> data = [
    _ChartData(1661396582, 35),
    _ChartData(1661400182, 28),
    _ChartData(1661403782, 34),
    _ChartData(1661407382, 32),
    _ChartData(1661418000, 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                // Chart title
                title: ChartTitle(text: 'Half yearly sales analysis'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_ChartData, DateTime>>[
                  LineSeries<_ChartData, DateTime>(
                      dataSource: data,
                      xValueMapper: (_ChartData sales, _) =>
                          DateTime.fromMicrosecondsSinceEpoch(sales.x * 1000),
                      yValueMapper: (_ChartData sales, _) => sales.y,
                      name: 'Sales',
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ]),
          ),
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final int x;
  final double y;
}

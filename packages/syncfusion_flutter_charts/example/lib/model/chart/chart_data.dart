import 'package:collection/collection.dart';
import 'package:lynus_mobile_core/model/device.dart';

import '../../charts/chart_bounds.dart';
import '../../charts/chart_periods.dart';
import 'lynus_point.dart';

class ChartData {
  Period period;
  List<ChartOption> chartOptions;

  /// Indices of the series that are shown (for correct color mapping). For
  /// example, this could correspond to a list of [0,1,2] when having 3 series.
  List<int> shownSeries;
  ChartBounds chartBounds;
  bool? showY;

  /// the data that should be displayed in the chart. the form is for example:
  /// data = [
  ///         [Point(0, 123),Point(1,456),Point(2,789)],  // variable 1
  ///         [Point(0, 123),Point(1,456),Point(2,789)],  // variable 2
  ///       ]
  List<List<LynusPoint>> data;

  /// stacking options (taken over from Highcharts). "normal" means stacking of
  /// columns is activated. `null` means that columns are displayed side by side.
  String? stackingOptions;

  /// threshold value for anomaly charts
  double? threshold;

  ChartData({
    required this.period,
    required this.chartOptions,
    required this.shownSeries,
    required this.chartBounds,
    this.data = const [],
    this.showY = true,
    this.stackingOptions,
    this.threshold,
  });

  bool get isMultiColumnChart =>
      chartOptions.where((element) => element.type == "column").length > 1;

  /// Returns all [ChartOption] elements which contain difference series.
  Map<int, ChartOption> get diffChartOptions => Map.fromEntries(chartOptions
      .mapIndexed((i, e) => MapEntry(i, e))
      .where((coEntry) => coEntry.value.agg == "diff"));

  /// Returns all [ChartOption] elements which contain non-difference series.
  Map<int, ChartOption> get nonDiffChartOptions => Map.fromEntries(chartOptions
      .mapIndexed((i, e) => MapEntry(i, e))
      .where((coEntry) => coEntry.value.agg != "diff"));
}

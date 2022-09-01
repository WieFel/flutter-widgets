import 'package:flutter/material.dart';

import '../model/chart/lynus_point.dart';
import 'chart_colors.dart';
import 'chart_periods.dart';

mixin ChartMixin {
  static const List<Period> _allPeriods = [
    Period.live,
    Period.hour,
    Period.day,
    Period.week,
    Period.month,
    Period.year,
  ];

  List<Period> get lineChartPeriods => _allPeriods;

  List<Period> get columnChartPeriods => _allPeriods
      .where((e) => ![Period.live, Period.hour].contains(e))
      .toList();

  /// Returns the series color list depending on the current theme.
  List<Color> seriesColors(BuildContext context) =>
      ChartColors.colors(Theme.of(context).brightness == Brightness.dark);

  /// Maps a data point to its respective x value.
  DateTime? xValueMapper(LynusPoint p, _) =>
      DateTime.fromMillisecondsSinceEpoch(p.x.toInt() * 1000);

  /// Maps a data point to its respective y value.
  num? yValueMapper(LynusPoint p, _) => p.y;
}

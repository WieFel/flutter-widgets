
import 'chart_bounds.dart';
import 'chart_periods.dart';

typedef PeriodBoundsFunction = ChartBounds Function();

class PeriodConfiguration {
  late Period period;
  late String interval;
  late int intervalInSeconds;
  late PeriodBoundsFunction periodBoundsFunction;
  late num tickInterval;
  late String tooltipFormat;
  late String format;
  late String? chartTitleFormat;

  PeriodConfiguration({
    required period,
    required this.interval,
    required this.intervalInSeconds,
    required this.periodBoundsFunction,
    required this.tickInterval,
    required this.tooltipFormat,
    required this.format,
    this.chartTitleFormat,
  });
}

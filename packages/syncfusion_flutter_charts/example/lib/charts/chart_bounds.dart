import 'package:intl/intl.dart';

import '../time_utils.dart';
import 'chart_periods.dart';

class ChartBounds {
  /// Start of chart data (and chart) in seconds since epoch.
  final int start;

  /// End of chart data in seconds since epoch.
  final int end;

  /// End of shown chart x-axis in seconds since epoch.
  final int endChart;

  const ChartBounds({
    required this.start,
    required this.end,
    required this.endChart,
  });
}

extension ChartBoundsExtension on ChartBounds {
  /// Creates a readable title from the given chart bounds object, according
  /// to the given period.
  String? titleForPeriod(Period period) {
    var start = DateTime.fromMillisecondsSinceEpoch(this.start * 1000);

    String? format = period.periodConfiguration.chartTitleFormat;
    if (format == null) return null;

    if (period != Period.week) {
      return DateFormat(format).format(start);
    } else {
      var endChart = DateTime.fromMillisecondsSinceEpoch(this.endChart * 1000);
      var formatter = DateFormat(format);
      return "${formatter.format(start)} - ${formatter.format(endChart)}";
    }
  }
}

ChartBounds getBounds(Period period, DateTime date) {
  ChartBounds bounds;
  switch (period) {
    case Period.hour:
      bounds = getHourBounds(date);
      break;
    case Period.day:
      bounds = getDayBounds(date);
      break;
    case Period.week:
      bounds = getWeekBounds(date);
      break;
    case Period.month:
      bounds = getMonthBounds(date);
      break;
    default:
      bounds = getYearBounds(date);
  }

  var now = toSecondsSinceEpoch(DateTime.now());

  // end cannot be in the future, to not load filled-up constant data
  return bounds.end > now
      ? ChartBounds(start: bounds.start, end: now, endChart: bounds.endChart)
      : bounds;
}

ChartBounds getHourBounds(DateTime date) {
  var d = DateTime(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.minute,
  );
  var selectedTime = toSecondsSinceEpoch(d);
  var end = toSecondsSinceEpoch(d.add(const Duration(hours: 1)));

  return ChartBounds(
    start: selectedTime,
    end: end,
    endChart: end,
  );
}

ChartBounds getDayBounds(DateTime date) {
  var selected = DateTime(date.year, date.month, date.day);
  var from = toSecondsSinceEpoch(selected);
  var to = toSecondsSinceEpoch(selected.add(const Duration(days: 1)));

  return ChartBounds(
    start: from,
    end: to,
    endChart: to,
  );
}

ChartBounds getWeekBounds(DateTime date) {
  const dayInSeconds = 86400;

  var selectedDate = DateTime(date.year, date.month, date.day);
  selectedDate =
      selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
  var from = toSecondsSinceEpoch(selectedDate);
  var to = from + (dayInSeconds * 7);
  var endChart = to;

  return ChartBounds(
    start: from,
    end: to,
    endChart: endChart,
  );
}

ChartBounds getMonthBounds(DateTime date) {
  var from = toSecondsSinceEpoch(DateTime(date.year, date.month, 1));
  var to = toSecondsSinceEpoch(DateTime(date.year, date.month + 1, 1));
  var endChart = toSecondsSinceEpoch(DateTime(date.year, date.month + 1));

  return ChartBounds(
    start: from,
    end: to,
    endChart: endChart,
  );
}

ChartBounds getYearBounds(DateTime date) {
  var from = toSecondsSinceEpoch(DateTime(date.year));
  var to = toSecondsSinceEpoch(DateTime(date.year + 1));
  var endChart = toSecondsSinceEpoch(DateTime(date.year + 1));

  return ChartBounds(
    start: from,
    end: to,
    endChart: endChart,
  );
}

/// Returns the given date modified with the according value corresponding to the
/// given period. If [next] is `true`, the next date is returned, else the
/// previous date is returned. (e.g. next day for 31.12.2020 would be 01.01.2021)
DateTime _modifyDate(DateTime date, Period period, bool next) {
  DateTime newDate;
  switch (period) {
    case Period.hour:
      newDate =
          date.add(next ? const Duration(hours: 1) : const Duration(hours: -1));
      break;
    case Period.day:
      newDate =
          date.add(next ? const Duration(days: 1) : const Duration(days: -1));
      break;
    case Period.week:
      newDate =
          date.add(next ? const Duration(days: 7) : const Duration(days: -7));
      break;
    case Period.month:
      // here we have to take into account that months differ in number of days
      newDate = DateTime(date.year, next ? date.month + 1 : date.month - 1);
      break;
    case Period.year:
      // here we have to take into account that year differ in number of days
      newDate = DateTime(next ? date.year + 1 : date.year - 1);
      break;
    default:
      newDate = date;
  }
  return newDate;
}

/// Returns the following date to the given one, according to the given period.
DateTime nextDate(DateTime date, Period period) =>
    _modifyDate(date, period, true);

/// Returns the previous date to the given one, according to the given period.
DateTime prevDate(DateTime date, Period period) =>
    _modifyDate(date, period, false);

import 'package:flutter/material.dart';

import '../chart_utils.dart';
import '../time_utils.dart';
import '../utils.dart';
import 'chart_bounds.dart';
import 'period_configuration.dart';

enum Period {
  live,
  hour,
  day,
  week,
  month,
  year,
  forecast6h,
  forecast24h,
}

extension PeriodExtension on Period {
  String get asString {
    switch (this) {
      case Period.live:
        return "live";
      case Period.hour:
        return "hour";
      case Period.day:
        return "day";
      case Period.week:
        return "week";
      case Period.month:
        return "month";
      case Period.year:
        return "year";
      case Period.forecast6h:
        return "forecast6h";
      case Period.forecast24h:
        return "forecast24h";
    }
  }

  static Period fromString(String s) {
    switch (s) {
      case "live":
        return Period.live;
      case "hour":
        return Period.hour;
      case "day":
        return Period.day;
      case "week":
        return Period.week;
      case "month":
        return Period.month;
      case "year":
        return Period.year;
      case "forecast6h":
        return Period.forecast6h;
      case "forecast24h":
        return Period.forecast24h;
      default:
        return Period.day;
    }
  }

  String asTranslatedDisplayString(BuildContext context) {
    switch (this) {
      case Period.live:
        return "chartPeriodLive";
      case Period.hour:
        return "chartPeriodHour";
      case Period.day:
        return "chartPeriodDay";
      case Period.week:
        return "chartPeriodWeek";
      case Period.month:
        return "chartPeriodMonth";
      case Period.year:
        return "chartPeriodYear";
      default:
        return "";
    }
  }

  String statisticsDialogTitle(BuildContext context) {
    switch (this) {
      case Period.hour:
        return "statisticsSelectedHour";
      case Period.day:
        return "statisticsSelectedDay";
      case Period.week:
        return "statisticsSelectedWeek";
      case Period.month:
        return "statisticsSelectedMonth";
      case Period.year:
        return "statisticsSelectedYear";
      default:
        return "";
    }
  }

  PeriodConfiguration get periodConfiguration {
    switch (this) {
      case Period.live:
        return PeriodConfiguration(
          period: Period.live,
          interval: "10s",
          intervalInSeconds: 10,
          periodBoundsFunction: () {
            var now = toSecondsSinceEpoch(DateTime.now());
            var start = now - 900; // 15 min before now

            return ChartBounds(
              start: start,
              end: now,
              endChart: now,
            );
          },
          tickInterval: 2 * 60,
          format: "HH:mm",
          tooltipFormat: "HH:mm:ss",
        );
      case Period.hour:
        return PeriodConfiguration(
          period: Period.hour,
          interval: "5s",
          intervalInSeconds: 5,
          periodBoundsFunction: () {
            var now = toSecondsSinceEpoch(DateTime.now());
            var start = now - 3600; // 1h before now

            return ChartBounds(
              start: start,
              end: now,
              endChart: now,
            );
          },
          tickInterval: 5 * 60,
          format: "HH:mm",
          tooltipFormat: "HH:mm:ss",
          chartTitleFormat: "dd. MMM yyyy, HH:mm",
        );
      case Period.day:
        return PeriodConfiguration(
          period: Period.day,
          interval: "5m",
          intervalInSeconds: 300,
          periodBoundsFunction: () {
            var dateNow = DateTime.now();
            var now = toSecondsSinceEpoch(dateNow);
            var start = toSecondsSinceEpoch(
                DateTime(dateNow.year, dateNow.month, dateNow.day));

            return ChartBounds(
              start: start,
              end: now,
              endChart: start + 86400,
            );
          },
          tickInterval: 4 * 3600,
          format: "HH:mm",
          tooltipFormat: "HH:mm",
          chartTitleFormat: "dd. MMM yyyy",
        );
      case Period.week:
        return PeriodConfiguration(
          period: Period.week,
          interval: "1h",
          intervalInSeconds: 3600,
          periodBoundsFunction: () {
            var dateNow = DateTime.now();
            var weekStart = toSecondsSinceEpoch(getWeekStartDate(dateNow));
            var now = toSecondsSinceEpoch(dateNow);
            var weekEnd = toSecondsSinceEpoch(getWeekEndDate(dateNow));

            return ChartBounds(
              start: weekStart,
              end: now,
              endChart: weekEnd,
            );
          },
          tickInterval: 24 * 3600,
          format: "E dd. MMM",
          tooltipFormat: "E, HH:mm",
          chartTitleFormat: "dd. MMM",
        );
      case Period.month:
        return PeriodConfiguration(
          period: Period.month,
          interval: "6h",
          intervalInSeconds: 21600,
          periodBoundsFunction: () {
            var date = DateTime.now();
            var start = DateTime(date.year, date.month);
            var end = DateTime(date.year, date.month + 1);

            return ChartBounds(
              start: toSecondsSinceEpoch(start),
              end: toSecondsSinceEpoch(date),
              endChart: toSecondsSinceEpoch(end),
            );
          },
          tickInterval: 24 * 3600,
          format: "dd. MMM",
          tooltipFormat: "dd.MM.",
          chartTitleFormat: "MMM yyyy",
        );
      case Period.year:
        return PeriodConfiguration(
            period: Period.year,
            interval: "1d",
            intervalInSeconds: 86400,
            periodBoundsFunction: () {
              var date = DateTime.now();

              var start = DateTime(date.year);
              var endChart = DateTime(date.year + 1);

              return ChartBounds(
                start: toSecondsSinceEpoch(start),
                end: toSecondsSinceEpoch(date),
                endChart: toSecondsSinceEpoch(endChart),
              );
            },
            tickInterval: 30 * 24 * 3600,
            format: "MMM y",
            tooltipFormat: "MM. yyyy",
            chartTitleFormat: "yyyy");
      case Period.forecast6h:
        return PeriodConfiguration(
          period: Period.forecast6h,
          interval: "5m",
          intervalInSeconds: 300,
          periodBoundsFunction: () {
            var date = getRoundedDate(15, DateTime.now());
            var start = toSecondsSinceEpoch(date);

            var end = start + 21600; // 6 hours after start

            return ChartBounds(
              start: start,
              end: end,
              endChart: end,
            );
          },
          tickInterval: 3600,
          format: "HH:mm",
          tooltipFormat: "dd. MMM HH:mm",
        );
      case Period.forecast24h:
        return PeriodConfiguration(
          period: Period.forecast24h,
          interval: "5m",
          intervalInSeconds: 300,
          periodBoundsFunction: () {
            var date = getRoundedDate(15, DateTime.now());

            var start = toSecondsSinceEpoch(date);

            var end = start + 21600 * 4; // 24 hours after start

            return ChartBounds(
              start: start,
              end: end,
              endChart: end,
            );
          },
          tickInterval: 4 * 3600,
          format: "HH:mm",
          tooltipFormat: "dd. MMM HH:mm",
        );
    }
  }
}

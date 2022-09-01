import 'package:collection/collection.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:lynus_mobile_core/model/device.dart';

import '../chart_utils.dart';
import '../model/chart/lynus_point.dart';
import 'chart_bounds.dart';
import 'chart_periods.dart';

const _expressionEvaluator = ExpressionEvaluator();

String replaceDots(String s) => s.replaceAll(".", "_");

/// Returns a list of variables in the order they appear within the
/// given expression.
List<String> getVariableNames(String expression) {
  return RegExp(r"[a-zA-Z@][\w\.]*")
      .allMatches(expression)
      .map((e) => e.group(0)!)
      .toList();
}

List<LynusPoint>? calculateResult(
    ChartOption co, Map<String, List<LynusPoint>> variableData) {
  var expression = co.calculation!.expression!;
  var variables = getVariableNames(expression);
  var aggregations = co.calculation!.aggregations!;

  expression = _addAggsToExpression(expression, aggregations);

  // if there are no variables in the expression, we just return "no data"
  // TODO handle this case if calculation series with constant values should be allowed
  if (variables.isEmpty) return null;

  // take the first appearing variable, to be able to loop over timestamp
  // entries.
  // it has the form [[<timestamp>, <value>], [<timestamp>, <value>], ...].
  // the actual values are ignored
  var key = keyFrom(variables.first, co.calculation!.aggregations!.first);
  List<LynusPoint> result = variableData[key]!.mapIndexed((i, e) {
    Map<String, num?> variableMapping = {};
    variables.forEachIndexed((j, v) {
      // get i-th value of variable's data points and extract it's value
      var k = keyFrom(v, aggregations[j]);

      // check if variable data of k has enough values, also catch null case of y
      variableMapping[k] =
          (variableData[k]!.length > i ? variableData[k]![i].y : null) ?? 0;
    });

    return LynusPoint(e.x, _calculate(expression, variableMapping));
  }).toList();

  return result;
}

num calculateSingleResult(String expression, Map<String, num> variables) =>
    _calculate(expression, variables);

/// Takes the given expression and adds the suffix "_<agg>" to each variable.
/// Returns the new expression string with the replaced names.
String _addAggsToExpression(String expression, List<String> aggregations) {
  var variableNames = getVariableNames(expression);
  var newExpression = "";
  variableNames.forEachIndexed((i, v) {
    // look for next occurrence of variable
    var foundIndex = expression.indexOf(v);
    // take part before found index
    newExpression += expression.substring(0, foundIndex);
    // add "<variable>_<agg>"
    newExpression += "${v}_${aggregations[i]}";
    // set expression to remaining part
    expression = expression.substring(foundIndex + v.length);
  });
  newExpression += expression;

  return newExpression;
}

/// Calculates the result of the expression for a specific data point, defined
/// by the [variableMapping].
num _calculate(String expression, Map<String, num?> variableMapping) {
  var expNoDots = replaceDots(expression).trim();
  Map<String, num?> mappingNoDots =
      variableMapping.map((key, value) => MapEntry(replaceDots(key), value));
  Expression e = Expression.parse(expNoDots);

  return _expressionEvaluator.eval(e, mappingNoDots);
}

List<LynusPoint> groupSeriesData(
  List<LynusPoint> data,
  Period period,
  String aggregation,
  ChartBounds chartBounds,
) {
  var separationPoints = _generateSeparationTimestamps(period, chartBounds);

  List<LynusPoint> groupedData = [];
  for (int i = 0; i < separationPoints.length - 1; i++) {
    var prevTimestamp = separationPoints[i];
    var nextTimestamp = separationPoints[i + 1];

    var group = data.where((LynusPoint p) {
      var t = p.x;
      return t >= prevTimestamp && t < nextTimestamp;
    }).toList();
    var values = group.map((LynusPoint p) => p.y).toList();
    groupedData.add(LynusPoint(
      prevTimestamp,
      values.isNotEmpty ? _calculateAggregation(values, aggregation) : null,
    ));
  }

  return groupedData;
}

/// Generates a list of separator timestamps for the given period, starting at
/// [chartBounds.start]. Timestamps are in seconds since epoch.
List<int> _generateSeparationTimestamps(
    Period period, ChartBounds chartBounds) {
  var date = DateTime.fromMillisecondsSinceEpoch(chartBounds.start * 1000);
  // points at which the groups are split, in seconds since epoch
  var separationPoints = [chartBounds.start]; // start at beginning
  var intervalInSeconds = period.periodConfiguration.tickInterval.toInt();
  switch (period) {
    case Period.month:
      // consider how many days a month has
      for (int i = 1;
          i <= DateUtils.getDaysInMonth(date.year, date.month);
          i++) {
        separationPoints.add(separationPoints.last + intervalInSeconds);
      }
      break;
    case Period.year:
      // consider how many days each month in the year has

      // loop through months. in dart, months are [1..12]
      for (int month = 1; month <= 12; month++) {
        var secondsOfMonth =
            DateUtils.getDaysInMonth(date.year, month) * 24 * 3600;
        separationPoints.add(separationPoints.last + secondsOfMonth);
      }
      break;
    default:
      var currentTimeStamp = separationPoints.first;
      // all other periods -> increase each point by same intervalInSeconds
      while (currentTimeStamp < chartBounds.endChart) {
        currentTimeStamp += intervalInSeconds;
        separationPoints.add(currentTimeStamp);
      }
  }

  return separationPoints;
}

num _calculateAggregation(List<num?> values, String aggregation) {
  var valuesWithoutNull = values.map((e) => e ?? 0);

  switch (aggregation) {
    case "avg":
      return valuesWithoutNull.average;
    case "min":
      return valuesWithoutNull.min;
    case "max":
      return valuesWithoutNull.max;
    case "last":
      return valuesWithoutNull.last;
    case "first":
      return valuesWithoutNull.first;
    case "diff":
      return valuesWithoutNull.sum;
    default:
      return valuesWithoutNull.average;
  }
}

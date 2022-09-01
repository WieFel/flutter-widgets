import 'package:lynus_mobile_core/model/device.dart';
import 'package:lynus_mobile_core/model/generic_device.dart';

/// Counts how many variables the [device] has.
int countChartVariables(GenericDevice device) =>
    device is Device && device.data!.mappings != null
        ? device.data!.mappings!.length
        : device.data!.chartOptions!.length;

/// Whether the given [device] is a wide chart (having more than a certain amount
/// of series/variables)
bool isWideChart(Device device) => (device.data!.chartOptions?.length ?? 0) > 3;

/// Whether the [device] represents a column chart
bool isMultiColumnChart(GenericDevice device) =>
    (device.data!.chartOptions
            ?.where((element) => element.type == "column")
            .length ??
        0) >
    1;

bool isLiveChart(GenericDevice device) =>
    (device.data!.chartOptions?.every((co) => co.type != "column") ?? false);

bool isView(ChartOption? chartOptions) {
  return chartOptions?.seriesType != 'Calculation';
}

bool isCalculation(ChartOption? chartOptions) {
  return chartOptions?.seriesType == 'Calculation';
}

/// Rounds the given [date] to the closest [minutes] interval.
DateTime getRoundedDate(int minutes, DateTime date) {
  var mRest = date.minute % minutes;
  var lastNMin = (date.minute ~/ minutes) * minutes;
  var nextNMin = ((date.minute ~/ minutes) + 1) * minutes;

  return DateTime(date.year, date.month, date.day, date.hour,
      mRest < minutes / 2 ? lastNMin : nextNMin);
}

bool allScalingsEqual(List<ChartOption> chartOptions) {
  var allMinScalings = chartOptions.map((e) => e.scaling?.min);
  var allMaxScalings = chartOptions.map((e) => e.scaling?.max);

  return allEqual(allMinScalings) && allEqual(allMaxScalings);
}

bool allUnitsEqual(List<ChartOption> chartOptions) =>
    allEqual(chartOptions.map((e) => e.unit));

bool allEqual(list) => list.every((e) => e != null && e == list.first);

String getSeriesName(ChartOption co, int index) {
  if (co.name != null && co.name?.isNotEmpty == true) {
    return co.name!;
  } else if (isView(co)) {
    return co.chartOptionVar!;
  } else {
    return "Calculation_$index";
  }
}

String keyFrom(String variable, String suffix) => "${variable}_$suffix";

/// Tries to cast the given list to a List<List<num>>. If not possible, it returns
/// an empty list.
List<List<num>> castToChartListOrEmpty(List? list) {
  try {
    return list?.map((e) => e.cast<num>()).toList().cast<List<num>>() ?? [];
  } catch (_) {
    return [];
  }
}

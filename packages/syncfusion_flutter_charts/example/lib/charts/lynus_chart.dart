import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lynus_mobile_core/model/device.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chart_utils.dart';
import '../model/chart/chart_data.dart';
import '../model/chart/lynus_point.dart';
import '../scrollbar_wrapper.dart';
import 'chart_bounds.dart';
import 'chart_math.dart';
import 'chart_mixin.dart';
import 'chart_periods.dart';
import 'period_configuration.dart';
import 'trackball_behavior.dart';

typedef ChartDataReadyCallback = void Function(SeriesData seriesData);

/// [LynusChart] is the main chart class that is used for showing a chart.
/// It internally uses the [WebViewChart], combines it with [PeriodToggleButtons]
/// and [ChartCalendarButton] and connects them all together.
class LynusChart extends StatelessWidget with ChartMixin {
  final ChartData data;
  final ChartDataReadyCallback? onChartDataReady;
  final List<Color>? useSeriesColors;
  final bool xAxisAutoScaling;
  final String? title;

  /// Default [LynusChart] without any background
  const LynusChart({
    Key? key,
    required this.data,
    this.onChartDataReady,
    this.useSeriesColors,
    this.xAxisAutoScaling = false,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var min = _period == Period.live
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_chartBounds.start * 1000);
    var max = _period == Period.live
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_chartBounds.endChart * 1000);

    var xAxis = _createXAxis(context, min, max);

    var seriesData = _generateSeries(context, data.data);
    onChartDataReady?.call(seriesData);

    var chart = Padding(
      // left padding added to resolve problem of chart cutting of y axis text
      // https://github.com/syncfusion/flutter-widgets/issues/536
      padding: EdgeInsets.only(
        left: 4.0 * _seriesCount,
        bottom: 8,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SfCartesianChart(
            title: title != null
                ? ChartTitle(
                    text: title!,
                    textStyle: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                : null,
            enableSideBySideSeriesPlacement: data.stackingOptions != "normal",
            primaryXAxis: xAxis,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            primaryYAxis: _createYAxis(context, 0),
            axes: !_scalingsAndUnitsEq ? _additionalYAxes(context) : null,
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              itemPadding: 0,
              padding: 0,
              toggleSeriesVisibility: false,
              orientation: LegendItemOrientation.horizontal,
              textStyle: Theme.of(context).textTheme.caption,
              legendItemBuilder: (legendText, series, point, seriesIndex) =>
                  _legendItemBuilder(
                context,
                constraints,
                legendText,
                series,
                point,
                seriesIndex,
              ),
            ),
            trackballBehavior: LynusTrackballBehavior(
              tooltipTimeFormat: _periodConfig.tooltipFormat,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              zoomMode: ZoomMode.x,
              enablePinching: true,
              enablePanning: true,
            ),
            series: seriesData.series,
          );
        },
      ),
    );

    return _chartShouldBeScrollable(context)
        // chart with more than 2 variables -> make wider and scrollable
        ? _makeChartScrollable(chart)
        : chart;
  }

  Widget _makeChartScrollable(Widget chart) {
    return ScrollbarWrapper(
      child: SizedBox(
        width: 500 + _seriesCount * 48,
        child: chart,
      ),
    );
  }

  _legendItemBuilder(
    BuildContext context,
    BoxConstraints constraints,
    legendText,
    series,
    point,
    seriesIndex,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 16,
            child: Divider(
              color: _getSeriesColor(context, seriesIndex),
              thickness: 3,
            ),
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            // TODO: improve this manually added -68px value
            constraints: BoxConstraints(maxWidth: constraints.maxWidth - 68),
            child: Text(
              legendText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ]),
      );

  _createXAxis(BuildContext context, DateTime? min, DateTime? max) {
    final DateFormat dateFormat = DateFormat(_periodConfig.format);
    final TextStyle labelStyle =
        Theme.of(context).textTheme.caption!.copyWith(fontSize: 11);

    return data.isMultiColumnChart
        ? DateTimeCategoryAxis(
            desiredIntervals: xAxisAutoScaling ? null : _desiredIntervals,
            // disable vertical grid lines
            majorGridLines: const MajorGridLines(width: 0),
            minimum: min,
            maximum: max,
            visibleMinimum: min,
            visibleMaximum: max,
            dateFormat: dateFormat,
            labelStyle: labelStyle,
            labelIntersectAction: AxisLabelIntersectAction.rotate90,
          )
        : DateTimeAxis(
            desiredIntervals: xAxisAutoScaling ? null : _desiredIntervals,
            majorGridLines: const MajorGridLines(width: 0),
            minimum: min,
            maximum: max,
            visibleMinimum: min,
            visibleMaximum: max,
            dateFormat: dateFormat,
            labelStyle: labelStyle,
            labelIntersectAction: AxisLabelIntersectAction.rotate90,
          );
  }

  /// A chart should be shown as scrollable chart if axes have different
  /// scalings/units, more than 2 series and the screen has less than 800
  /// pixels width.
  bool _chartShouldBeScrollable(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return !_scalingsAndUnitsEq &&
        _shownSeries.length > 2 &&
        _showY &&
        screenWidth < 800;
  }

  get _xAxisIntervalSize =>
      data.period.periodConfiguration.tickInterval.toDouble();

  get _desiredIntervals {
    var intervals = (data.chartBounds.endChart - data.chartBounds.start) ~/
        _xAxisIntervalSize;

    // use only half of the interval number when showing month
    if (data.period == Period.month) intervals ~/= 2;

    return intervals;
  }

  bool get _scalingsAndUnitsEq =>
      allScalingsEqual(_chartOptions) && allUnitsEqual(_chartOptions);

  Period get _period => data.period;

  ChartBounds get _chartBounds => data.chartBounds;

  List<ChartOption> get _chartOptions => data.chartOptions;

  PeriodConfiguration get _periodConfig => _period.periodConfiguration;

  List<int> get _shownSeries => data.shownSeries;

  bool get _showY => data.showY ?? true;

  int get _seriesCount => _shownSeries.length;

  List<ChartAxis> _additionalYAxes(BuildContext context) =>
      // skip first axis, as it is already handled in main chart as primary axis
      List.generate(_chartOptions.length - 1, (index) => index + 1)
          .map((i) => _createYAxis(context, i))
          .toList();

  ChartAxis _createYAxis(BuildContext context, int index) {
    var co = _chartOptions[index];
    return NumericAxis(
      name: "y$index",
      labelFormat: "{value} ${co.unit}",
      labelStyle: !_scalingsAndUnitsEq
          ? TextStyle(color: _getSeriesColor(context, _shownSeries[index]))
          : null,
      placeLabelsNearAxisLine: true,
      minimum: co.scaling?.min,
      maximum: co.scaling?.max,
      isVisible: _showY,
      plotBands: <PlotBand>[
        if (data.threshold != null && _isLastAxis(index))
          _thresholdSeries(context),
      ],
      labelsExtent: _period == Period.live ? 48 : null,
    );
  }

  /// take index modulo length to restart at beginning, if there are
  /// more series than colors
  Color _getSeriesColor(BuildContext context, int index) {
    var colors = useSeriesColors ?? seriesColors(context);
    return colors[index % colors.length];
  }

  _thresholdSeries(BuildContext context) => PlotBand(
        text: "Threshold",
        start: data.threshold!,
        end: data.threshold!,
        textStyle: Theme.of(context).textTheme.caption,
        horizontalTextAlignment: TextAnchor.end,
        horizontalTextPadding: "-1%",
        verticalTextPadding: "1%",
        borderColor: Colors.green,
        borderWidth: 2,
        dashArray: const [10, 10],
      );

  SeriesData _generateSeries(
      BuildContext context, List<List<LynusPoint>> data) {
    List<ChartSeriesController> seriesControllers = [];

    var series = _chartOptions.mapIndexed((index, co) {
      late XyDataSeries<LynusPoint, DateTime> series;
      // the index the series had within the shownSeries list
      int originalSeriesIndex = _shownSeries[index];

      switch (co.type) {
        case "column":
          {
            var groupedData = groupSeriesData(
              data[index],
              _period,
              co.agg!,
              _chartBounds,
            );
            series = ColumnSeries<LynusPoint, DateTime>(
              dataSource: groupedData,
              xValueMapper: xValueMapper,
              yValueMapper: yValueMapper,
              name: getSeriesName(co, index),
              yAxisName: "y$index",
              color: _getSeriesColor(context, originalSeriesIndex),
              onRendererCreated: (ChartSeriesController controller) {
                seriesControllers.add(controller);
              },
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.gap),
            );
            break;
          }
        case "area":
          var c = _getSeriesColor(context, originalSeriesIndex);
          series = AreaSeries<LynusPoint, DateTime>(
            dataSource: data[index],
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            name: getSeriesName(co, index),
            yAxisName: "y$index",
            color: c.withOpacity(.7),
            onRendererCreated: (ChartSeriesController controller) {
              seriesControllers.add(controller);
            },
            borderColor: c,
            borderWidth: 1,
          );
          break;
        default:
          {
            // we have to differentiate between live chart and other charts
            if (_period == Period.live || data[index].isEmpty) {
              // for live chart (or empty chart) we use LineSeries, which auto scrolls
              series = LineSeries<LynusPoint, DateTime>(
                dataSource: data[index],
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                name: getSeriesName(co, index),
                yAxisName: "y$index",
                color: _getSeriesColor(context, originalSeriesIndex),
                onRendererCreated: (ChartSeriesController controller) {
                  seriesControllers.add(controller);
                },
              );
            } else {
              // for all other charts we use FastLineSeries, as they don't need
              // auto scroll. Fast line series is more efficient when having
              // many data points.
              series = FastLineSeries<LynusPoint, DateTime>(
                dataSource: data[index],
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
                name: getSeriesName(co, index),
                yAxisName: "y$index",
                color: _getSeriesColor(context, originalSeriesIndex),
                onRendererCreated: (ChartSeriesController controller) {
                  seriesControllers.add(controller);
                },
              );
            }
          }
      }

      return series;
    }).toList();

    return SeriesData(series, seriesControllers);
  }

  bool _isLastAxis(int index) => index == _shownSeries.length - 1;
}

class SeriesData {
  List<XyDataSeries<LynusPoint, DateTime>> series;
  List<ChartSeriesController> seriesControllers;

  SeriesData(this.series, this.seriesControllers);
}

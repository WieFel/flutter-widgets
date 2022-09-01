import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils.dart';

class ChartTooltip extends StatelessWidget {
  final TrackballDetails trackballDetails;
  final String tooltipTimeFormat;

  const ChartTooltip({
    Key? key,
    required this.trackballDetails,
    required this.tooltipTimeFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var points = trackballDetails.groupingModeInfo!.points;
    var pointsIndices = trackballDetails.groupingModeInfo!.currentPointIndices;
    var series = trackballDetails.groupingModeInfo!.visibleSeriesList;

    // from the visible series, we take the one with the highest index,
    // because that implies that the x-point of that series will be the most
    // exact one
    var seriesIndex = argmax(pointsIndices);
    var timeStamp =
        DateFormat(tooltipTimeFormat).format(points[seriesIndex].x as DateTime);

    return Card(
      color: Theme.of(context).cardColor.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: IntrinsicHeight(
        child: SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                ChartTooltipHeader(timeStamp: timeStamp),
                Divider(
                  indent: 4,
                  endIndent: 4,
                  color: Theme.of(context).dividerColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: List.generate(
                      points.length,
                      (index) => ChartTooltipItem(
                        color: series[index].color,
                        name: series[index].name ?? "",
                        yValue: points[index].y,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartTooltipHeader extends StatelessWidget {
  const ChartTooltipHeader({
    Key? key,
    required this.timeStamp,
  }) : super(key: key);

  final String timeStamp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.hourglass_bottom,
          size: 16,
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(timeStamp)),
      ],
    );
  }
}

class ChartTooltipItem extends StatelessWidget {
  final Color? color;
  final String name;
  final num yValue;

  const ChartTooltipItem({
    Key? key,
    required this.color,
    required this.name,
    required this.yValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            name,
            style: TextStyle(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "${yValue}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

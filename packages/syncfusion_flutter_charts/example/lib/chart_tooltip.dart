import 'package:flutter/material.dart';
import 'package:supercharged_dart/supercharged_dart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    var series = trackballDetails.groupingModeInfo!.visibleSeriesList;

    var timeStamp = points[_getSeriesIndexWithMostTimestamps(series)].x;

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
                Row(
                  children: [
                    const Icon(
                      Icons.lock_clock,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(child: Text(timeStamp)),
                  ],
                ),
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
                      (index) => Row(
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: series[index].color,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              series[index].name ?? "",
                              style: TextStyle(color: series[index].color),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (points[index].y as num).toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: series[index].color,
                            ),
                          ),
                        ],
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

  int _getSeriesIndexWithMostTimestamps(List<CartesianSeries> series) {
    List<int> seriesLengths = series.map((e) => e.dataSource.length).toList();
    var mostTimestamps = seriesLengths.max();
    return seriesLengths.indexOf(mostTimestamps!);
  }
}

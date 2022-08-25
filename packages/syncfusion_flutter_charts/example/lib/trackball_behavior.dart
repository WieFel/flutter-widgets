import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chart_tooltip.dart';

// ignore must be immutable warning, as we cannot influence TrackballBehavior class
//ignore: must_be_immutable
class LynusTrackballBehavior extends TrackballBehavior {
  final String tooltipTimeFormat;

  LynusTrackballBehavior({
    required this.tooltipTimeFormat,
  }) : super(
          enable: true,
          markerSettings: const TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible,
            height: 8,
            width: 8,
            borderWidth: 4,
          ),
          activationMode: ActivationMode.longPress,
          hideDelay: 3000,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          tooltipAlignment: ChartAlignment.near,
          builder: (BuildContext context, TrackballDetails trackballDetails) =>
              ChartTooltip(
            trackballDetails: trackballDetails,
            tooltipTimeFormat: tooltipTimeFormat,
          ),
          includeYAxisExceedingPoints: true,
        );
}

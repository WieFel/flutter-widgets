/// Helper function to extract all y-values form a list of [LynusPoint]s.
List<num?> yValuesFrom(List<LynusPoint> points) =>
    points.map((e) => e.y).toList();

/// A representation of a point in the chart data.
class LynusPoint {
  num x;
  num? y;

  LynusPoint(this.x, this.y);
}

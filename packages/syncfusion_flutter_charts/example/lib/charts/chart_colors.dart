import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ChartColors {
  static const List<Color> _colors = [
    Color(0xff0f72ba),
    Color(0xff00c853),
    Color(0xfff57c00),
    Color(0xff8085e9),
    Color(0xfff34848),
    Color(0xff2baae2),
    Color(0xff009688),
    Color(0xffee3562),
    Color(0xff7cb342),
  ];

  static List<Color> colors(bool isDarkTheme) => isDarkTheme
      ? _colors.map((e) => e.lighten(10)).toList()
      : _colors.map((e) => e.darken(2)).toList();
}

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

/// Replaces all dashes in [s] with underscores.
String replaceDashes(String s) => s.replaceAll("-", "_");

/// Extracts a number from the given string [s].
int extractNumberFromString(String s) =>
    int.parse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? "0");

/// Multiplies [value] with [multiplier] if [value] is not null. Otherwise it
/// returns null.
multiplyOrNull(double? value, double multiplier) =>
    value != null ? value * multiplier : null;

/// Returns [s] if it is defined and not empty, else it returns [alternative].
stringOrAlt(String? s, String? alternative) =>
    s != null && s.isNotEmpty ? s : alternative;

/// Tries to convert the given String to a [DateTime] object.
/// If conversion fails, it returns null.
DateTime? hourStringToDateTime(String hourMinutesString) {
  try {
    return DateFormat("HH:mm").parse(hourMinutesString);
  } on FormatException catch (_) {
    return null;
  }
}

/// Tries to convert the given String to a [DateTime] object.
/// If conversion fails, it returns null.
int? hourStringToMinutes(String hourMinutesString) {
  var d = hourStringToDateTime(hourMinutesString);
  if (d == null) return null;

  return d.hour * 60 + d.minute;
}

/// Tries to convert the given String to a [DateTime] object.
/// If conversion fails, it returns null.
String minutesToHourString(int? minutes) {
  if (minutes == null) return "";

  var hours = minutes ~/ 60;
  var min = minutes % 60;

  return "${hours.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}";
}

List<T> filterNotNull<T>(List<T?> listWithNulls) =>
    listWithNulls.where((e) => e != null).toList().cast();

/// For any given date (e.g. 13.10.2000 being a Tuesday), this function returns
/// the respective Monday in the same week as a [DateTime]. In the given example,
/// this would be Monday 12.10.2000.
DateTime getWeekStartDate(DateTime date) {
  var d = date.subtract(Duration(days: date.weekday - 1));
  return DateTime(d.year, d.month, d.day);
}

/// For any given date (e.g. 13.10.2000 being a Tuesday), this function returns
/// the respective Sunday in the same week as a [DateTime]. In the given example,
/// this would be Sunday 18.10.2000.
DateTime getWeekEndDate(DateTime date) =>
    getWeekStartDate(date).add(const Duration(days: 7));

/// Returns the index with the maximum element of the list.
int argmax(List<num> list) => list
    .mapIndexed((i, e) => [i, e])
    .reduce((r, current) => current[1] > r[1] ? current : r)
    .first
    .toInt();

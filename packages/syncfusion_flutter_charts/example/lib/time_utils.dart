/// Converts the given [DateTime] instance to a number indicating the seconds
/// since epoch.
int toSecondsSinceEpoch(DateTime? dateTime) {
  return (dateTime ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
}

DateTime fromSecondsSiceEpoch(int seconds) =>
    DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

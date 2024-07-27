import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/day.dart';

/// Information about a single Ramowka entry.
class RamowkaInfo implements Comparable<RamowkaInfo> {
  /// Creates an empty [RamowkaInfo] object.
  RamowkaInfo.empty()
      : title = '',
        startTime = '',
        endTime = '',
        day = Day.today();

  /// Creates a [RamowkaInfo] object from a given Json map.
  RamowkaInfo.fromJson(Map<String, dynamic> jsonData)
      : title = parseTitle(jsonData['title']['rendered'] as String),
        startTime = parseTime(jsonData['acf']['start_time'] as String),
        endTime = parseTime(jsonData['acf']['end_time'] as String),
        day = Day.fromString(jsonData['acf']['day'] as String);

  final String title;
  final String startTime;
  final String endTime;
  final Day day;

  /// Parses time string to the required format
  static String parseTime(String time) =>
      time.removeTrailing('0').removeTrailing(':');

  /// Parses title string to the required format
  static String parseTitle(String title) => title
      .replaceAll('&#8217;', "'")
      .replaceFirst('(Replay)', ' - powtórka')
      .replaceFirst('(Live)', '');

  @override
  String toString() {
    return '''
    Ramowka(
      title: `$title`, 
      startTime: `$startTime`, 
      endTime: `$endTime`,
      day: `$day`
    )
    ''';
  }

  @override
  int compareTo(RamowkaInfo other) => startTime.compareTo(other.startTime);
}

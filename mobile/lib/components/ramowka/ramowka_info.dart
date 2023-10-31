import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/day.dart';

/// Information about a single Ramowka entry.
class RamowkaInfo {
  const RamowkaInfo({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  /// Creates an empty [RamowkaInfo] object.
  RamowkaInfo.empty()
      : title = '',
        startTime = '',
        endTime = '',
        day = Day.today();

  /// Creates a [RamowkaInfo] object from a given Json map.
  RamowkaInfo.fromJson(Map<String, dynamic> jsonData)
      : title = parseTitle(
          (jsonData['title'] as Map<String, dynamic>)['rendered'].toString(),
        ),
        startTime = parseTime(
          (jsonData['acf'] as Map<String, dynamic>)['start_time'].toString(),
        ),
        endTime = parseTime(
          (jsonData['acf'] as Map<String, dynamic>)['end_time'].toString(),
        ),
        day = Day.fromString(
          (jsonData['acf'] as Map<String, dynamic>)['day'].toString(),
        );

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
}

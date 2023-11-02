import 'package:intl/intl.dart';

/// Days of the week
enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static Day fromString(String s) => values.byName(s.toLowerCase());

  static Day today() =>
      fromString(DateFormat.EEEE().format(DateTime.now()).toLowerCase());

  static Day tomorrow() => Day.values[(today().index + 1) % 7];
}

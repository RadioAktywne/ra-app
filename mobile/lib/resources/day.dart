import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radioaktywne/extensions/extensions.dart';

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

  static Day tomorrow() => Day.values[(today().index + 1) % values.length];

  static Day byIndex(int index) => Day.values[index];

  String toL10nString(BuildContext context) => switch (this) {
        monday => context.l10n.monday,
        tuesday => context.l10n.tuesday,
        wednesday => context.l10n.wednesday,
        thursday => context.l10n.thursday,
        friday => context.l10n.friday,
        saturday => context.l10n.saturday,
        sunday => context.l10n.sunday,
      };

  @override
  String toString() => name;
}

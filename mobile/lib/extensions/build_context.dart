import 'package:flutter/material.dart';
import 'package:radioaktywne/resources/colors.dart';

extension BuildContextTheme on BuildContext {
  RAColors get colors => RAColors.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);
}

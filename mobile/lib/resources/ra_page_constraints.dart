import 'package:flutter/material.dart';

/// Constants representing page constraints
/// that have to be accessible all over the app.
abstract class RaPageConstraints {
  const RaPageConstraints._();

  static const double ramowkaListRowHeight = 22;
  static const double pagePaddingValue = 16;
  static const EdgeInsets outerWidgetPagePadding =
      EdgeInsets.symmetric(horizontal: pagePaddingValue);
  static const EdgeInsets outerTextPagePadding =
      EdgeInsets.symmetric(horizontal: 26);
  static const EdgeInsets pagePadding = EdgeInsets.only(
    top: pagePaddingValue,
    bottom: radioPlayerPadding,
    left: pagePaddingValue,
    right: pagePaddingValue,
  );
  static const double radioPlayerHeight = 50;
  static const double radioPlayerPadding = 1.5 * radioPlayerHeight;
}

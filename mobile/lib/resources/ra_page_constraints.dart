import 'package:flutter/material.dart';

/// Constants representing page constraints
/// that have to be accessible all over the app.
abstract class RaPageConstraints {
  const RaPageConstraints._();

  static const double pagePadding = 16;
  static const EdgeInsets outerWidgetPagePadding =
      EdgeInsets.symmetric(horizontal: pagePadding);
  static const EdgeInsets outerTextPagePadding =
      EdgeInsets.symmetric(horizontal: 26);
  static const double radioPlayerHeight = 50;
  static const double radioPlayerPadding = 1.5 * radioPlayerHeight;
}

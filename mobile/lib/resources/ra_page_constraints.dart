import 'package:flutter/material.dart';

/// Constants representing page constraints
/// that have to be accessible all over the app.
abstract class RaPageConstraints {
  const RaPageConstraints._();

  static const EdgeInsets outerWidgetPagePadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets outerTextPagePadding =
      EdgeInsets.symmetric(horizontal: 26);
  // TODO: change for some padding (e.g. 1.5 * this) for
  // TODO: more clarity about it's purpose
  static const double radioPlayerHeight = 50;
}

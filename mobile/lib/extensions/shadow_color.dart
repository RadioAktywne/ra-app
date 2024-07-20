import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/themes.dart';

extension ShadowColor on BuildContext {
  /// Determines color of a "shadow" behind a widget in a list.
  Color shadowColor(int index) {
    final colors = <Color>[
      this.colors.highlightRed,
      this.colors.highlightYellow,
      this.colors.highlightGreen,
      this.colors.highlightBlue,
    ];

    return colors[index % colors.length];
  }
}

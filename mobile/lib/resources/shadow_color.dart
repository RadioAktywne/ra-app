import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// Determines color of a "shadow" behind a widget in a list.
Color shadowColor(BuildContext context, int index) {
  final colors = <Color>[
    context.colors.highlightRed,
    context.colors.highlightYellow,
    context.colors.highlightGreen,
    context.colors.highlightBlue,
  ];

  return colors[index % colors.length];
}

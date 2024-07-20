import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';

/// Refresh indicator with predefined style to match
/// the app theme and the Platform.
class RaRefreshIndicator extends StatelessWidget {
  const RaRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  /// The widget below this widget in the widget tree
  final Widget child;

  /// A function that's called when the user has dragged
  /// the refresh indicator far enough to demonstrate that
  /// they want the app to refresh. The returned [Future]
  /// must complete when the refresh operation is finished.
  final Future<void> Function() onRefresh;

  /// The progress indicator's foreground color.
  ///
  /// [context.colors.highlightGreen] on default.
  final Color? color;

  /// The progress indicator's background color.
  ///
  /// [context.colors.backgroundDark] on default.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      color: color ?? context.colors.highlightGreen,
      backgroundColor: backgroundColor ?? context.colors.backgroundDark,
      displacement: 0,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

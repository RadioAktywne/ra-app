import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// A [ListView] that can be refreshed. It pulls the data
/// from the source specified in the [controller].
///
/// The [controller] __should be__ provided by
/// the [useRefreshableListViewController] function.
///
/// Example usage (inside widget's `build()` method):
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   final controller = useRefreshableListViewController(
///     <someDefaultValue>,
///     <someFetchFunction>,
///     hasData: ...,
///   );
///   return RefreshableListView(
///     controller: controller,
///     child: ...,
///     ...,
///   );
/// }
/// ```
class RefreshableListView<T> extends HookWidget {
  const RefreshableListView({
    super.key,
    required this.controller,
    required this.childWaiting,
    required this.childNoData,
    required this.child,
    this.refreshIndicatorColor,
    this.refreshIndicatorBackgroundColor,
  });

  final Widget childWaiting;
  final Widget childNoData;
  final Widget child;

  final RefreshableListViewController<T> controller;

  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: refreshIndicatorColor ?? context.colors.highlightGreen,
      backgroundColor:
          refreshIndicatorBackgroundColor ?? context.colors.backgroundDark,
      displacement: 0,
      onRefresh: () async =>
          controller.state.value = await controller.fetchFunction(),
      child: controller.snapshot.connectionState == ConnectionState.waiting
          ? childWaiting
          : _decideVariant(),
    );
  }

  /// Decides, which variant of child to render
  /// based on the snapshot and the provided function
  Widget _decideVariant() {
    if (!controller.hasData(controller.state.value)) {
      return childNoData;
    }
    return child;
  }
}

/// Sets up everything needed for fetching and
/// re-fetching data (usually using a
/// [RefreshableListView] widget).
///
/// This is a hook and should be used as such -
/// at the top of the Widget's `build()` function.
///
/// [defaultValue] - default value of the fetched data
/// [fetchFunction] - function for fetching and re-fetching data
/// [hasData] - function for determining the current state
RefreshableListViewController<T> useRefreshableListViewController<T>(
  T defaultValue,
  Future<T> Function() fetchFunction, {
  bool Function(T)? hasData,
}) {
  final state = useState(defaultValue);
  final future = useMemoized(fetchFunction);
  final snapshot = useFuture(future);

  /// Called only on the first time the widget
  /// is rendered, because of the empty list argument.
  useEffect(
    () {
      future.then((e) => state.value = e);
      // nothing to dispose of
      return;
    },
    [],
  );

  return RefreshableListViewController._(
    state: state,
    snapshot: snapshot,
    fetchFunction: fetchFunction,
    hasData: hasData ?? (_) => snapshot.hasData,
  );
}

/// A simple data class used for controlling
/// the state of [RefreshableListView] widget.
class RefreshableListViewController<T> {
  /// Private constructor - to prevent
  /// instantiating this class.
  ///
  /// To instantiate - use
  /// [useRefreshableListViewController] function.
  const RefreshableListViewController._({
    required this.state,
    required this.snapshot,
    required this.fetchFunction,
    required this.hasData,
  });

  final ValueNotifier<T> state;
  final AsyncSnapshot<T> snapshot;
  final Future<T> Function() fetchFunction;
  final bool Function(T) hasData;
}

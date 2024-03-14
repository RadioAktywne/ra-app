import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// A [ListView] that can be refreshed. It pulls the data
/// from the source specified in the [controller].
///
/// The [controller] __has to__ be provided by
/// the [useRefreshableFetchController] function.
///
/// The [child] and [childNoData] __have to__ be scrollable
/// for them to be refreshable.
///
/// Example usage (inside widget's `build()` method):
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   final controller = useRefreshableFetchController(
///     <someDefaultValue>,
///     <someFetchFunction>,
///     hasData: ...,
///   );
///   return RefreshableFetchWidget(
///     controller: controller,
///     child: ...,
///     ...,
///   );
/// }
/// ```
class RefreshableFetchWidget<T> extends HookWidget {
  const RefreshableFetchWidget({
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

  final RefreshableFetchController<T> controller;

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
/// [RefreshableFetchWidget] widget).
///
/// This function is a hook and should be used as such -
/// at the top of the widget's `build()` function.
///
/// [defaultValue] - default value of the fetched data
///
/// [fetchFunction] - function for fetching and re-fetching data
///
/// [hasData] - function for checking if the completed future has
///   data by checking the `controller.state.value`. On
///   default: the `controller.snapshot.hasData` is used instead.
RefreshableFetchController<T> useRefreshableFetchController<T>(
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

  return RefreshableFetchController._(
    state: state,
    snapshot: snapshot,
    fetchFunction: fetchFunction,
    hasData: hasData ?? (_) => snapshot.hasData,
  );
}

/// A simple data class used for controlling
/// the state of [RefreshableFetchWidget] widget.
class RefreshableFetchController<T> {
  /// Private constructor - to prevent
  /// instantiating this class manually.
  ///
  /// To get an instance - call
  /// [useRefreshableFetchController] function.
  const RefreshableFetchController._({
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

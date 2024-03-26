import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// A [ListView] that can be refreshed. It pulls the data
/// from the source specified in the [controller].
///
/// The [controller] _has to_ be provided by
/// the [useRefreshableFetchController] function.
///
/// The [child] and [childNoData] _have to_ be scrollable
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

  /// Child widget to be displayed in the widget's loading state.
  final Widget childWaiting;

  /// Child widget to be displayed in case the data couldn't be loaded.
  final Widget childNoData;

  /// Child widget to be displayed when the data is successfully loaded.
  final Widget child;

  /// Controller of the widget's inner state.
  ///
  /// _Has to_ be provided by the [useRefreshableFetchController] hook.
  final RefreshableFetchController<T> controller;

  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;

  @override
  Widget build(BuildContext context) {
    // TODO: change this to use builders instead of a passed-in 'hook'
    // TODO: example:
    /// Add parameter `data` to builders so that the widget's inner data can be
    /// used in the widget's definition.
    /// ```dart
    /// return RefrechableFetchWidget(
    ///   childBuilder: (context, data) => ...,
    ///   childWaitingBuilder: (context, data) => ...,
    ///   childNoDataBuilder: (context,data) => ...,
    ///   ...,
    /// );
    /// ```
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

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// A widget that can be used to easily build elements
/// that pull data from an async source and need to be
/// able to be refreshed.
///
/// For this widget to work, the children built by
/// the builders _have to_ be [Scrollable], e.g. a
/// [ListView] or a [SingleChildScrollView].
class RefreshableFetchWidget<T> extends HookWidget {
  const RefreshableFetchWidget({
    super.key,
    required this.defaultData,
    required this.fetchFunction,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.childBuilder,
    this.refreshIndicatorColor,
    this.refreshIndicatorBackgroundColor,
    this.hasData,
  });

  /// The default value of the data that is going to be fetched.
  final T defaultData;

  /// Function used for fetching the data.
  final Future<T> Function() fetchFunction;

  /// Child widget to be displayed in the widget's loading state.
  final Widget Function(BuildContext, AsyncSnapshot<T>) loadingBuilder;

  /// Child widget to be displayed in case the data couldn't be loaded.
  final Widget Function(BuildContext) errorBuilder;

  /// Child widget to be displayed when the data is successfully loaded.
  final Widget Function(BuildContext, T) childBuilder;

  /// Function used for determining if the data was successfully
  /// loaded.
  ///
  /// On default, snapshot.hasData is used.
  final bool Function(T)? hasData;

  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final data = _useRefreshableFetchController(defaultData, fetchFunction);

    return RefreshIndicator(
      color: refreshIndicatorColor ?? context.colors.highlightGreen,
      backgroundColor:
          refreshIndicatorBackgroundColor ?? context.colors.backgroundDark,
      displacement: 0,
      onRefresh: () async => data.state.value = await fetchFunction(),
      child: data.snapshot.connectionState == ConnectionState.waiting
          ? loadingBuilder(context, data.snapshot)
          : _decideVariant(context, data),
    );
  }

  /// Decides, which variant of child to render
  /// based on the snapshot and the provided function
  Widget _decideVariant(
    BuildContext context,
    RefreshableFetchController<T> data,
  ) {
    if (hasData != null ? hasData!(data.state.value) : data.snapshot.hasData) {
      return errorBuilder(context);
    }
    return childBuilder(context, data.state.value);
  }
}

/// Sets up every hook needed for fetching, loading and
/// re-fetching data.
///
/// This function is a hook and should be used as such -
/// at the top of the widget's `build()` function.
///
/// [defaultValue] - default value of the fetched data.
///
/// [fetchFunction] - function for fetching and re-fetching data
RefreshableFetchController<T> _useRefreshableFetchController<T>(
  T defaultValue,
  Future<T> Function() fetchFunction,
) {
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
  );
}

/// A simple data class used for controlling
/// the state of [RefreshableFetchWidget] widget.
class RefreshableFetchController<T> {
  /// Private constructor - to prevent
  /// instantiating this class manually.
  ///
  /// To get an instance - call
  /// [_useRefreshableFetchController] function.
  const RefreshableFetchController._({
    required this.state,
    required this.snapshot,
  });

  final ValueNotifier<T> state;
  final AsyncSnapshot<T> snapshot;
}

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/ra_refresh_indicator.dart';

typedef AsyncValueGetter<T> = Future<T> Function();

/// A widget that can be used to easily build elements
/// that pull data from an async source and need to be
/// able to be refreshed.
///
/// For this widget to work, the widgets built by
/// [builder] and [errorBuilder] _have to_ be
/// [Scrollable], e.g. a [ListView] or a
/// [SingleChildScrollView], so that they
/// can be refreshed.
class RefreshableFetchWidget<T> extends HookWidget {
  const RefreshableFetchWidget({
    super.key,
    required this.defaultData,
    required this.onFetch,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.builder,
    required this.hasData,
  });

  /// The default value of the data that is going to be fetched.
  final T defaultData;

  /// An async source of the data.
  ///
  /// Called once on initial render and once on every refresh.
  final AsyncValueGetter<T> onFetch;

  /// A builder that specifies the widget to be displayed while
  /// the data is still loading.
  final Widget Function(BuildContext, AsyncSnapshot<T>) loadingBuilder;

  /// A builder that is called when the data couldn't be loaded.
  final Widget Function(BuildContext) errorBuilder;

  /// A builder that specifies a widget to be displayed on
  /// successfully loading the data.
  final Widget Function(BuildContext, T) builder;

  /// Determines if the data was successfully loaded.
  final bool Function(T) hasData;

  @override
  Widget build(BuildContext context) {
    final data = _useRefreshableFetchController(defaultData, onFetch);

    return RaRefreshIndicator(
      onRefresh: () async => data.state.value = await onFetch(),
      child: data.snapshot.connectionState == ConnectionState.waiting
          ? loadingBuilder(context, data.snapshot)
          : _decideVariant(context, data),
    );
  }

  /// Decides, which variant of child to render
  /// based on the snapshot and the provided function
  Widget _decideVariant(
    BuildContext context,
    _RefreshableFetchController<T> data,
  ) {
    if (hasData(data.state.value)) {
      return builder(context, data.state.value);
    }
    return errorBuilder(context);
  }
}

/// Sets up hooks needed for fetching, loading and
/// re-fetching data.
///
/// This function is a hook and should be used as such -
/// at the top of the widget's `build()` function.
///
/// [defaultValue] - default value of the fetched data.
///
/// [fetchFunction] - function for fetching and re-fetching data
_RefreshableFetchController<T> _useRefreshableFetchController<T>(
  T defaultValue,
  AsyncValueGetter<T> fetchFunction,
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

  return _RefreshableFetchController(
    state: state,
    snapshot: snapshot,
  );
}

/// A simple hook wrapper used for controlling
/// the state of [RefreshableFetchWidget] widget.
class _RefreshableFetchController<T> {
  const _RefreshableFetchController({
    required this.state,
    required this.snapshot,
  });

  final ValueNotifier<T> state;
  final AsyncSnapshot<T> snapshot;
}

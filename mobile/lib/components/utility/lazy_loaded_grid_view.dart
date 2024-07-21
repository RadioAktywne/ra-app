import 'dart:async';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/resources.dart';
import 'package:radioaktywne/resources/shadow_color.dart';

class LazyLoadedGridView<T> extends HookWidget {
  const LazyLoadedGridView({
    super.key,
    required this.dataUri,
    required this.fromJson,
    required this.onItemTap,
    required this.thumbnailPath,
    required this.title,
    this.timeout = const Duration(seconds: 15),
    this.padding = RaPageConstraints.pagePadding,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: RaPageConstraints.pagePaddingValue,
      mainAxisSpacing: RaPageConstraints.pagePaddingValue,
    ),
  });

  final Uri dataUri;

  final T Function(Map<String, dynamic>) fromJson;
  final void Function(T data, int index) onItemTap;

  final String Function(T) thumbnailPath;
  final String Function(T) title;

  final Duration timeout;

  final EdgeInsets padding;

  final SliverGridDelegateWithFixedCrossAxisCount gridDelegate;

  @override
  Widget build(BuildContext context) {
    final lazyLoadingController = useLazyLoadingController(dataUri, fromJson);

    if (lazyLoadingController.isLoading &&
        lazyLoadingController.items.isEmpty) {
      return const RaProgressIndicator();
    }

    if (lazyLoadingController.hasError && lazyLoadingController.items.isEmpty) {
      return RefreshIndicator(
        color: context.colors.highlightGreen,
        backgroundColor: context.colors.backgroundDark,
        onRefresh: () async {
          lazyLoadingController.hasMore = true;
          await lazyLoadingController.fetchItems();
        },
        child: const RaErrorPage(),
      );
    }

    return GridView.builder(
      controller: lazyLoadingController.scrollController,
      padding: padding,
      gridDelegate: gridDelegate,
      itemCount: lazyLoadingController.items.length,
      itemBuilder: (context, index) {
        final item = lazyLoadingController.items.elementAt(index);
        return GestureDetector(
          onTap: () => onItemTap(item, index),
          child: ColorShadowedCard(
            shadowColor: shadowColor(context, index),
            child: ImageWithOverlay(
              thumbnailPath: thumbnailPath(item),
              titleOverlay: Text(
                htmlUnescape.convert(title(item)),
                // possibly context.textStyles.textSmallGreen, up to RA to decide
                style: context.textStyles.textMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ),
        );
      },
    );
  }
}

// TODO: return a list of [LazyLoadedGridViewItem]s
_LazyLoadingController<T> useLazyLoadingController<T>(
  Uri uri,
  T Function(Map<String, dynamic>) fromJson,
) {
  final scrollController = useScrollController();
  final items = useState<Iterable<T>>([]);
  final currentPage = useState(1);
  final isLoading = useState(false);
  final hasMore = useState(true);
  final hasError = useState(false);

  Future<void> fetchItems() async {
    if (isLoading.value || !hasMore.value) {
      return;
    }
    isLoading.value = true;
    hasError.value = false;

    final pageUri = Uri.parse(
      '$uri&page=${currentPage.value}&per_page=16',
    );

    try {
      final newItems = await fetchData(pageUri, fromJson);
      if (newItems.isNotEmpty) {
        currentPage.value++;
        items.value = [...items.value, ...newItems];
      } else {
        hasMore.value = false;
      }
    } on TimeoutException catch (_) {
      hasError.value = true;
    } catch (e) {
      hasError.value = true;
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(
    () {
      fetchItems();
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !isLoading.value &&
            hasMore.value) {
          fetchItems();
        }
      });
      return scrollController.dispose;
    },
    [],
  );

  return _LazyLoadingController(
    scrollController: scrollController,
    items: items,
    currentPage: currentPage,
    isLoading: isLoading,
    hasMore: hasMore,
    hasError: hasError,
    fetchItems: fetchItems,
  );
}

class _LazyLoadingController<T> {
  _LazyLoadingController({
    required this.scrollController,
    required ValueNotifier<Iterable<T>> items,
    required ValueNotifier<int> currentPage,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> hasMore,
    required ValueNotifier<bool> hasError,
    required this.fetchItems,
  })  : _items = items,
        _currentPage = currentPage,
        _isLoading = isLoading,
        _hasMore = hasMore,
        _hasError = hasError;

  final ScrollController scrollController;
  final ValueNotifier<Iterable<T>> _items;
  final ValueNotifier<int> _currentPage;
  final ValueNotifier<bool> _isLoading;
  final ValueNotifier<bool> _hasMore;
  final ValueNotifier<bool> _hasError;
  final Future<void> Function() fetchItems;

  Iterable<T> get items => _items.value;
  int get currentPage => _currentPage.value;
  bool get isLoading => _isLoading.value;
  bool get hasMore => _hasMore.value;
  bool get hasError => _hasError.value;

  set hasMore(bool value) => _hasMore.value = value;
}

class LazyLoadedGridViewItem {
  const LazyLoadedGridViewItem({
    required this.title,
    required this.thumbnailPath,
  });

  final String title;
  final String thumbnailPath;
}

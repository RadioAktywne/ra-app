import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/ra_refresh_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class ArticleSelectionPage extends HookWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    final hooks = _useArticleSelectionHooks();

    if (hooks.isLoading && hooks.articles.isEmpty) {
      return const RaProgressIndicator();
    }

    if (hooks.hasError && hooks.articles.isEmpty) {
      return RaRefreshIndicator(
        onRefresh: () async {
          hooks.hasMore = true;
          await hooks.fetchArticles();
        },
        child: const RaErrorPage(),
      );
    }

    return GridView.builder(
      controller: hooks.scrollController,
      padding: RaPageConstraints.outerWidgetPagePadding.copyWith(
        top: RaPageConstraints.pagePadding,
        bottom: RaPageConstraints.radioPlayerPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: RaPageConstraints.pagePadding,
        mainAxisSpacing: RaPageConstraints.pagePadding,
      ),
      itemCount: hooks.articles.length,
      itemBuilder: (context, index) {
        final article = hooks.articles.elementAt(index);
        return GestureDetector(
          onTap: () => context.push(
            RaRoutes.articleId(article.id),
            extra: article,
          ),
          child: ColorShadowedCard(
            shadowColor: context.shadowColor(index),
            child: ImageWithOverlay(
              thumbnailPath: article.thumbnail,
              titleOverlay: Text(
                HtmlUnescape().convert(article.title),
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

  _ArticleSelectionHooks _useArticleSelectionHooks() {
    final scrollController = useScrollController();
    final articles = useState<Iterable<ArticleInfo>>([]);
    final currentPage = useState(1);
    final isLoading = useState(false);
    final hasMore = useState(true);
    final hasError = useState(false);

    Future<void> fetchArticles() async {
      if (isLoading.value || !hasMore.value) {
        return;
      }
      isLoading.value = true;
      hasError.value = false;

      final pageUri = Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=${currentPage.value}&per_page=16',
      );

      try {
        final newArticles = await fetchData(pageUri, ArticleInfo.fromJson);
        if (newArticles.isNotEmpty) {
          currentPage.value++;
          articles.value = [...articles.value, ...newArticles];
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
        fetchArticles();
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent - 200 &&
              !isLoading.value &&
              hasMore.value) {
            fetchArticles();
          }
        });
        return scrollController.dispose;
      },
      [],
    );

    return _ArticleSelectionHooks(
      scrollController: scrollController,
      articles: articles,
      currentPage: currentPage,
      isLoading: isLoading,
      hasMore: hasMore,
      hasError: hasError,
      fetchArticles: fetchArticles,
    );
  }
}

class _ArticleSelectionHooks {
  _ArticleSelectionHooks({
    required this.scrollController,
    required ValueNotifier<Iterable<ArticleInfo>> articles,
    required ValueNotifier<int> currentPage,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> hasMore,
    required ValueNotifier<bool> hasError,
    required this.fetchArticles,
  })  : _articles = articles,
        _currentPage = currentPage,
        _isLoading = isLoading,
        _hasMore = hasMore,
        _hasError = hasError;

  final ScrollController scrollController;
  final ValueNotifier<Iterable<ArticleInfo>> _articles;
  final ValueNotifier<int> _currentPage;
  final ValueNotifier<bool> _isLoading;
  final ValueNotifier<bool> _hasMore;
  final ValueNotifier<bool> _hasError;
  final Future<void> Function() fetchArticles;

  Iterable<ArticleInfo> get articles => _articles.value;
  int get currentPage => _currentPage.value;
  bool get isLoading => _isLoading.value;
  bool get hasMore => _hasMore.value;
  bool get hasError => _hasError.value;

  set hasMore(bool value) => _hasMore.value = value;
}

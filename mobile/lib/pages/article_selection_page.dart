import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card_2.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/shadow_color.dart';
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
      return const _ArticleSelectionWaiting();
    }

    if (hooks.hasError && hooks.articles.isEmpty) {
      return RefreshIndicator(
        color: context.colors.highlightGreen,
        backgroundColor: context.colors.backgroundDark,
        onRefresh: () async {
          hooks.hasMore = true;
          await hooks.fetchArticles();
        },
        child: const _ArticleSelectionNoData(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: RaPageConstraints.radioPlayerHeight,
      ), // Helps with the player not covering the last article
      child: GridView.builder(
        controller: hooks.scrollController,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: hooks.articles.length,
        itemBuilder: (context, index) {
          final article = hooks.articles.elementAt(index);
          return GestureDetector(
            onTap: () => context.push(
              RaRoutes.articleId(article.id),
              extra: article,
            ),
            child: ColorShadowedCard2(
              shadowColor: shadowColor(context, index),
              footer: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  HtmlUnescape().convert(article.title),
                  style: context.textStyles.textSmall.copyWith(
                    color: context.colors.highlightGreen,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
              child: Image.network(
                article.thumbnail,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null
                        ? const Center(child: RaProgressIndicator())
                        : child,
                errorBuilder: (context, error, stackTrace) => AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Image.asset(
                      'assets/defaultMedia.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
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

class _ArticleSelectionNoData extends StatelessWidget {
  const _ArticleSelectionNoData();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            maxHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: RaPageConstraints.outerTextPagePadding,
              child: Text(
                context.l10n.dataLoadError,
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.highlightGreen,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleSelectionWaiting extends StatelessWidget {
  const _ArticleSelectionWaiting();

  @override
  Widget build(BuildContext context) {
    return const RaProgressIndicator();
  }
}

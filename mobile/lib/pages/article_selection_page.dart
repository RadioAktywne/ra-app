import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card_2.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/shadow_color.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class ArticleSelectionPage extends StatefulWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  @override
  _ArticleSelectionPageState createState() => _ArticleSelectionPageState();
}

class _ArticleSelectionPageState extends State<ArticleSelectionPage> {
  final ScrollController _scrollController = ScrollController();
  final List<ArticleInfo> _articles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<Iterable<ArticleInfo>> _fetchArticles() async {
    if (_isLoading || !_hasMore) {
      return [];
    }
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final pageUri = Uri.parse(
      'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=$_currentPage&per_page=16',
    );

    try {
      final newArticles = await fetchData(pageUri, ArticleInfo.fromJson);
      setState(() {
        _articles.addAll(newArticles);
        _currentPage++;
        _isLoading = false;
        _hasMore = newArticles.isNotEmpty;
      });
      return newArticles;
    } on TimeoutException catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return [];
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _hasMore = false;
      });
      return [];
    }
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _fetchArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchArticles,
      defaultData: [ArticleInfo.empty()],
      hasData: (articles) => _articles.isNotEmpty,
      loadingBuilder: (context, snapshot) {
        if (_isLoading) {
          return const _ArticleSelectionWaiting();
        } else {
          return Container();
        }
      },
      errorBuilder: (context) {
        if (_hasError) {
          return const _ArticleSelectionNoData();
        } else {
          return Container();
        }
      },
      builder: (context, articles) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 50), // Helps with the player not covering the last article
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20), // Space around the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20, // Space between columns
              mainAxisSpacing: 20, // Space between rows
            ),
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              final article = _articles.elementAt(index);
              return GestureDetector(
                onTap: () => context.push(
                  RaRoutes.articleId(article.id),
                  extra: article,
                ),
                child: ColorShadowedCard2(
                  shadowColor: shadowColor(context, index),
                  footer: DefaultTextStyle(
                    style: context.textStyles.textSmall.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: HtmlWidget(article.title),
                    ),
                  ),
                  child: Image.network(
                    article.thumbnail,
                    fit: BoxFit.fill,
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
      },
    );
  }
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

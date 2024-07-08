import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card_2.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/shadow_color.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class ArticleSelectionPage extends StatelessWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  // Single URL that returns all articles
  // TODO: Lazy loading and loading every article not one page of articles
  static final Uri _infoUrl = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=1&per_page=16',
  );

  Future<Iterable<ArticleInfo>> _fetchArticles() async {
    try {
      return await fetchData(_infoUrl, ArticleInfo.fromJson);
    } on TimeoutException catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchArticles,
      defaultData: const <ArticleInfo>[],
      hasData: (articles) => articles.isNotEmpty,
      loadingBuilder: (context, snapshot) => const _ArticleSelectionWaiting(),
      errorBuilder: (context) => const _ArticleSelectionNoData(),
      builder: (context, articles) {
        return GridView.builder(
          padding: const EdgeInsets.only(
            bottom: RaPageConstraints.radioPlayerPadding,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                onTap: () => context.push(
                  RaRoutes.articleId(article.id),
                  extra: article,
                ),
                child: ColorShadowedCard2(
                  shadowColor: shadowColor(context, index),
                  footer: DefaultTextStyle(
                    style: context.textStyles.textSmallGreen.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: HtmlWidget(article.title),
                    ),
                  ),
                  child: Image.network(
                    article.thumbnail,
                    errorBuilder: (context, error, stackTrace) => AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: Image.asset('assets/defaultMedia.png'),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ArticleSelectionNoData extends StatelessWidget {
  const _ArticleSelectionNoData();

  @override
  Widget build(BuildContext context) {
    return const RaErrorPage();
  }
}

class _ArticleSelectionWaiting extends StatelessWidget {
  const _ArticleSelectionWaiting();

  @override
  Widget build(BuildContext context) {
    return const RaProgressIndicator();
  }
}

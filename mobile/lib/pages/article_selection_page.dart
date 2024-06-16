import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:radioaktywne/components/utility/color_shadowed_card_2.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/article_page.dart';

class ArticleSelectionPage extends StatelessWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 26);

  // Single URL that returns all articles
  static final Uri _infoUrl = Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=1&per_page=16');

  Future<List<ArticleInfo>> _fetchArticles() async {
    final articles = <ArticleInfo>[];

    try {
      final response = await http.get(_infoUrl).timeout(timeout);
      final jsonDataList = jsonDecode(response.body) as List<dynamic>;

      for (final jsonData in jsonDataList) {
        final article = ArticleInfo.fromJson(jsonData as Map<String, dynamic>);
        articles.add(article);
      }
    } catch (_) {
      articles.add(ArticleInfo.empty());
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchArticles,
      defaultData: [ArticleInfo.empty()],
      loadingBuilder: (context, snapshot) => const _ArticleSelectionWaiting(),
      errorBuilder: (context) => const _ArticleSelectionNoData(),
      builder: (context, articles) {
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20), // Add top padding here
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // This creates two columns
              mainAxisSpacing: 20, 
            ),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                // TODO: Add proper navigation to the article page
                child: GestureDetector(
                  onTap: () {
                    Navigator.push<ArticlePage>(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlePage(article: article,)),
                    );
                  },
                  child: ColorShadowedCard2(
                    shadowColor: context.colors.highlightBlue,
                    footer: DefaultTextStyle(
                      style: context.textStyles.textMedium.copyWith(
                        color: context.colors.highlightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      child: HtmlWidget(article.title),
                    ),
                    child: Image.network(article.thumbnail),
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
              padding: ArticleSelectionPage._pagePadding.copyWith(top: 0),
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

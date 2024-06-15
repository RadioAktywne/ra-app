import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_selection_info.dart';

class ArticleSelectionPage extends StatelessWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 26);

  static final List<Uri> _infoUrls = [
    Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media?include[]=2253'),
    Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media?include[]=2247'),
    Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media?_embed=true&include[]=1878'),
    Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/media?_embed=true&include[]=1866'),
    // Add more URLs here
  ];

Future<List<ArticleSelectionInfo>> _fetchArticles() async {
  final articles = <ArticleSelectionInfo>[];

  for (final url in _infoUrls) {
    try {
      final response = await http.get(url).timeout(timeout);
      final jsonDataList = jsonDecode(response.body) as List<dynamic>;
      for (final jsonData in jsonDataList) {
        final article = ArticleSelectionInfo.fromJson(jsonData as Map<String, dynamic>);
        articles.add(article);
      }
    } catch (_) {
      articles.add(ArticleSelectionInfo.empty());
    }
  }

  return articles;
}

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchArticles,
      defaultData: [ArticleSelectionInfo.empty()],
      loadingBuilder: (context, snapshot) => const _ArticleSelectionWaiting(),
      errorBuilder: (context) => const _ArticleSelectionNoData(),
      builder: (context, articles) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // This creates two columns
          ),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Image.network(article.thumbnail);
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

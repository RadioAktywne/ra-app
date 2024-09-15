import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/lazy_loaded_grid_view.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/router/ra_routes.dart';

/// Allow for browsing articles.
class ArticleSelectionPage extends StatelessWidget {
  const ArticleSelectionPage({
    super.key,
    this.perPage = 16,
    this.timeout = const Duration(seconds: 15),
  });

  final int perPage;

  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    return LazyLoadedGridView(
      fetchPage: (page) async {
        final pageUri = Uri.https(
          RaApi.baseUrl,
          RaApi.endpoints.posts,
          {
            '_embed': true,
            'page': page,
            'per_page': perPage,
          }.valuesToString(),
        );
        return fetchData(pageUri, ArticleInfo.fromJson, timeout: timeout);
      },
      itemBuilder: (article) => LazyLoadedGridViewItem(
        title: article.title,
        thumbnailPath: article.thumbnail,
      ),
      onItemTap: (article, index) => context.push(
        RaRoutes.articleId(article.id),
        extra: article,
      ),
    );
  }
}

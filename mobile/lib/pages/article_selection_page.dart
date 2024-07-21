import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/lazy_loaded_grid_view.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class ArticleSelectionPage extends StatelessWidget {
  const ArticleSelectionPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  static final Uri _articlesUri = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true',
  );

  @override
  Widget build(BuildContext context) {
    return LazyLoadedGridView(
      dataUri: _articlesUri,
      fromJson: ArticleInfo.fromJson,
      transformItem: (article) => LazyLoadedGridViewItem(
        title: article.title,
        thumbnailPath: article.thumbnail,
      ),
      onItemTap: (article, index) => context.push(
        RaRoutes.articleId(article.id),
        extra: article,
      ),
      timeout: timeout,
    );
  }
}

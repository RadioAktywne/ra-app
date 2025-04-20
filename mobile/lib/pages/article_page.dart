import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/pages/templates/ra_page_template.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';

/// Page displaying a single article.
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.id,
  });

  final int id;

  Uri get uri => Uri.https(
        RaApi.baseUrl,
        RaApi.endpoints.post(id),
        {'_embed': true}.valuesToString(),
      );

  @override
  Widget build(BuildContext context) {
    return RaPageTemplate<ArticleInfo>(
      onFetch: () async => fetchSingle(uri, ArticleInfo.fromJson),
      defaultData: ArticleInfo.empty(),
      hasData: (article) => article.isNotEmpty,
      itemBuilder: (article) => RaPageTemplateItem(
        image: article.fullImage,
        title: article.title,
        content: article.content,
      ),
    );
  }
}

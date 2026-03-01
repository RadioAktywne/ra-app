import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/newest_widget/newest_widget_template.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class NewestArticleWidget extends StatelessWidget {
  const NewestArticleWidget({super.key, this.shadowColor});

  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return NewestWidgetTemplate(
      title: context.l10n.newestArticles,
      fetchData: () => fetchNewest(
        RaApi.baseUrl,
        RaApi.endpoints.posts,
        ArticleInfo.fromJson,
      ),
      itemBuilder: (context, article) => NewestWidgetTemplateItem(
        thumbnailPath: article.thumbnail ?? article.fullImage,
        title: article.title,
        onClick: () => context.go(RaRoutes.articleId(article.id)),
      ),
      shadowColor: shadowColor,
    );
  }
}

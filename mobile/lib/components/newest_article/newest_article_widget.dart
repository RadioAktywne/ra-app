import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/newest_article/newest_articles_fetch.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class NewestArticleWidget extends HookWidget {
  const NewestArticleWidget({
    super.key,
    this.shadowColor,
  });

  /// Shadow color for the card.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final articles = useState<Iterable<ArticleInfo>>([]);
    final hasError = useState(false);
    final isLoading = useState(false);

    useEffect(
      () {
        isLoading.value = true;
        final newestArticleFetch = NewestArticleFetch();
        newestArticleFetch.loadArticles().then((_) {
          isLoading.value = false;
          articles.value = newestArticleFetch.articles;
          hasError.value = newestArticleFetch.hasError;
        });
        return null;
      },
      [],
    );

    final defaultShadowColor = context.colors.highlightYellow;

    return SwipeableCard(
      items: articles.value.mapIndexed(
        (index, item) {
          return SwipeableCardItem(
            thumbnailPath: item.thumbnail,
            title: item.title,
            onTap: () {
              context.push(
                RaRoutes.articleId(item.id),
                extra: item,
              );
            },
          );
        },
      ),
      shadowColor: shadowColor ?? defaultShadowColor,
      header: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: RaPageConstraints.headerTextPaddingLeft,
        ),
        child: Text(
          'Najnowsze artykuły',
          style: context.textStyles.textSmallGreen,
        ),
      ),
      isLoading: isLoading.value,
      hasError: hasError.value,
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/newest_article/newest_articles_fetch.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class NewestArticleWidget extends HookWidget {
  const NewestArticleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final articles = useState<Iterable<ArticleInfo>>([]);
    final isLoading = useState(false);
    final hasError = useState(false);

    useEffect(
      () {
        final newestArticleFetch = NewestArticleFetch();
        isLoading.value = true;
        newestArticleFetch.loadArticles().then((_) {
          articles.value = newestArticleFetch.articles;
          isLoading.value = newestArticleFetch.isLoading;
          hasError.value = newestArticleFetch.hasError;
        });
        return null;
      },
      [],
    );

    return SwipeableCard(
      items: articles.value.mapIndexed(
        (index, item) {
          return SwipeableCardItem(
            id: item.id,
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
      isLoading: isLoading.value,
      shadowColor: context.colors.highlightYellow,
      header: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          'Najnowsze artykuły',
          style: context.textStyles.textSmallGreen,
        ),
      ),
    );
  }
}

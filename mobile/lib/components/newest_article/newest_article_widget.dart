import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class NewestArticleWidget extends StatelessWidget {

  const NewestArticleWidget({
    super.key,
    required this.articles,
    required this.isLoading,
    required this.hasError,
  });
  final Iterable<ArticleInfo> articles;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: SwipeableCard(
          items: articles.mapIndexed(
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
          isLoading: isLoading,
          shadowColor: context.colors.highlightYellow,
          header: Padding(
            padding: const EdgeInsets.all(3),
            child: Text(
              'Najnowsze artykuły',
              style: context.textStyles.textSmall,
            ),
          ),
        ),
      ),
    );
  }
}

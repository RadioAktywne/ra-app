import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class SwipableCard extends HookWidget {
  const SwipableCard({
    super.key,
    required this.articles,
    required this.isLoading,
    required this.shadowColor,
    this.header,
  });

  final Iterable<ArticleInfo> articles;
  final bool isLoading;
  final Color shadowColor;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return ColorShadowedWidget(
      shadowColor: shadowColor,
      child: Container(
        color: context.colors.backgroundDark,
        padding: const EdgeInsets.all(3),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PageView.builder(
                controller: pageController,
                itemCount: articles.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final article = articles.elementAt(index);
                  return GestureDetector(
                    onTap: () => context.push(
                      RaRoutes.articleId(article.id),
                      extra: article,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            color: context.colors.backgroundDarkSecondary,
                            child: isLoading ? 
                              Image.asset(
                                'assets/defaultMedia.png',
                                fit: BoxFit.fill,
                              ) : Image.network(
                                article.thumbnail,
                                fit: BoxFit.fill,
                              ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Opacity(
                            opacity: 0.8,
                            child: Container(
                              color: context.colors.backgroundDark,
                              child: DefaultTextStyle(
                                style: context.textStyles.textSmall.copyWith(
                                  color: context.colors.highlightGreen,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: HtmlWidget(article.title),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: context.colors.backgroundDark,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(articles.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage.value == index
                                ? context.colors.highlightGreen
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            if (header != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: context.colors.backgroundDark,
                  child: header,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

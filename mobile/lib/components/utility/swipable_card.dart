import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/utility/color_shadowed_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/router/ra_routes.dart';

class SwipableCard extends StatefulWidget {
  const SwipableCard({
    super.key,
    required this.articles,
    required this.shadowColor,
    this.header,
  });

  final Iterable<ArticleInfo> articles;
  final Color shadowColor;
  final Widget? header;

  @override
  _SwipableCardState createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColorShadowedWidget(
      shadowColor: widget.shadowColor,
      child: Container(
        color: context.colors.backgroundDark,
        padding: const EdgeInsets.all(3),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.articles.length,
                itemBuilder: (context, index) {
                  final article = widget.articles.elementAt(index);
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
                            child: Image.network(
                              article.thumbnail,
                              fit: BoxFit.cover,
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
                    children: List.generate(widget.articles.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
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
            if (widget.header != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: context.colors.backgroundDark,
                  child: widget.header,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

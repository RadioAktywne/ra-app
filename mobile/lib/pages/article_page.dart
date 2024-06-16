import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';

class ArticlePage extends StatelessWidget {

  const ArticlePage({
    super.key,
    required this.article,
  });
  final ArticleInfo article;

  /// Paddings
  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);
  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 26);

  /// Space between things on the page.
  static const SizedBox _emptySpace = SizedBox(height: 9);
  static const SizedBox _spaceFromTop = SizedBox(height: 26);

  @override
  Widget build(BuildContext context) {
    // TODO: After adding proper navigation this Container should be romoved
    return Container(
      color: context.colors.backgroundLight,
      child: Padding(
        padding: _pagePadding,
        child: ListView(
          children: [
            _spaceFromTop,
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                article.fullImage,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? FittedBox(
                            fit: BoxFit.fitWidth,
                            clipBehavior: Clip.hardEdge,
                            child: child,
                          )
                        : Container(
                            color: context.colors.backgroundDarkSecondary,
                            child: const RaProgressIndicator(),
                          ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    context.l10n.imageLoadError,
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
            _emptySpace,
            Container(
              height: 31,
              color: context.colors.backgroundDark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _textPadding,
                    child: SelectionArea(
                      child: DefaultTextStyle(
                        style: context.textStyles.textMedium.copyWith(
                          color: context.colors.backgroundLight,
                        ),
                        child: HtmlWidget(article.title),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _emptySpace,
            Padding(
              padding: _textPadding,
              child: SelectionArea(
                child: DefaultTextStyle(
                  style: context.textStyles.textSmall.copyWith(
                    color: context.colors.backgroundDark,
                  ),
                  child: HtmlWidget(article.content),
                ),
              ),
            ),
            _emptySpace,
          ],
        ),
      ),
    );
  }
}

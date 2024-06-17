import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
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
              child: Align(
                alignment:Alignment.centerLeft,
                child:
                  CustomPaddingHtmlWidget(
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.backgroundLight,
                    ),
                    htmlContent: article.title,
                  ),
              ),
            ),
            _emptySpace,
            CustomPaddingHtmlWidget(
              style: context.textStyles.textSmall.copyWith(
                color: context.colors.backgroundDark,
              ),
              htmlContent: article.content,
            ),
            _emptySpace,
          ],
        ),
      ),
    );
  }
}

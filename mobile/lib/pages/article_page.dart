import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Page displaying a single article.
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.article,
  });
  final ArticleInfo article;

  /// Space between things on the page.
  static const SizedBox _emptySpace = SizedBox(height: 9);

  /// Space from the top of the page.
  static const SizedBox _spaceFromTop = SizedBox(height: 26);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundLight,
      child: Padding(
        padding: RaPageConstraints.outerTextPagePadding,
        child: ListView(
          children: [
            _spaceFromTop,
            Image.network(
              article.fullImage,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : Container(
                          color: context.colors.backgroundDarkSecondary,
                          child: const RaProgressIndicator(),
                        ),
              errorBuilder: (_, __, ___) => Center(
                child: Image.asset('assets/defaultMedia.png'),
              ),
            ),
            _emptySpace,
            Container(
              color: context.colors.backgroundDark,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaddingHtmlWidget(
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.backgroundLight,
                    ),
                    htmlContent: article.title,
                  ),
                ),
              ),
            ),
            _emptySpace,
            CustomPaddingHtmlWidget(
              style: context.textStyles.textSmallGreen.copyWith(
                color: context.colors.backgroundDark,
              ),
              htmlContent: article.content,
            ),
            SizedBox(height: context.playerPaddingValue),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  /// Fetch timeout
  final Duration timeout;

  /// Paddings
  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);
  static const EdgeInsets _pagePadding = EdgeInsets.only(top: 26, left: 26, right: 26);

  /// Space between things on the page.
  static const SizedBox _emptySpace = SizedBox(height: 9);

  /// Article info fetch details.
  static final Uri _infoUrl = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=1&per_page=16',
  );
  static const _infoHeaders = {'Content-Type': 'application/json'};

  static Uri _imgUrl(String id) => Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/media?include[]=$id',
      );
  static const _imgHeaders = {'Content-Type': 'image/jpeg'};

  /// Fetch current article from radioaktywne.pl api.
  Future<ArticleInfo> _fetchArticle() async {
    try {
      final data = await fetchData(
        _infoUrl,
        ArticleInfo.fromJson,
        headers: _infoHeaders,
        timeout: timeout,
      );

      final articlePage = data.first;

      final imageUrls = await fetchData(
        _imgUrl(articlePage.imageTag),
        (e) => (e['guid'] as Map<String, dynamic>)['rendered'] as String,
        headers: _imgHeaders,
        timeout: timeout,
      );

      final imageUrl = imageUrls.first;
      articlePage.imageTag = imageUrl;

      return articlePage;

    } on TimeoutException catch (_) {
      return ArticleInfo.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchArticle,
      defaultData: ArticleInfo.empty(),
      loadingBuilder: (context, snapshot) => const _ArticleWaiting(),
      errorBuilder: (context) => const _ArticleNoData(),
      builder: (context, article) => Padding(
        padding: _pagePadding,
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                article.imageTag,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Container(
                            color: context.colors.backgroundDarkSecondary,
                            child: Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: context.colors.highlightGreen,
                                  strokeWidth: 5,
                                ),
                              ),
                            ),
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
              color: context.colors.backgroundDark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _textPadding,
                    child: Html(
                      data: article.title,
                      style: {
                        'html': Style(
                          color: context.colors.backgroundLight, // Adjust text color
                          fontSize: FontSize(context.textStyles.textMedium.fontSize!),
                           fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
            _emptySpace,
            Padding(
              padding: _textPadding,
              child: Html(
                data: article.content,
                style: {
                  'html': Style(
                    color: context.colors.backgroundDark, // Adjust text color
                    fontSize: FontSize(context.textStyles.textSmall.fontSize!),
                  ),
                },
              ),
            ),
            _emptySpace,
          ],
        ),
      ),
    );
  }
}

/// Empty variant of the [ArticlePage], to be
/// displayed when data cannot be fetched.
class _ArticleNoData extends StatelessWidget {
  const _ArticleNoData();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            maxHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: ArticlePage._pagePadding.copyWith(top: 0),
              child: Text(
                context.l10n.dataLoadError,
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.highlightGreen,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading variant of [ArticlePage], displaying
/// loading animation.
class _ArticleWaiting extends StatelessWidget {
  const _ArticleWaiting();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.highlightGreen,
        strokeWidth: 5,
      ),
    );
  }
}

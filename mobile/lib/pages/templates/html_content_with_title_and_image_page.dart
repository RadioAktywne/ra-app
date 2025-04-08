import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Template for page with an image on top, a (optional)
/// title, and content text
class HtmlContentWithTitleAndImagePage<T> extends StatelessWidget {
  const HtmlContentWithTitleAndImagePage({
    super.key,
    required this.onFetch,
    required this.defaultData,
    required this.hasData,
    required this.imageUrl,
    required this.title,
    required this.content,
  });

  /// Function to fetch the page data.
  final Future<T> Function() onFetch;

  /// Default data to be displayed before the page fully loads.
  final T defaultData;

  /// Function to determine if the fetched data
  /// is proper.
  final bool Function(T) hasData;

  /// Function to extract imageUrl from fetched object of type T.
  /// Image.asset is identified as the returned path starting with 'assets/'
  /// Everything else is rendered as Image.network.
  final String Function(T) imageUrl;

  /// Function to extract title from fetched object of type T.
  /// If empty string is returned, title block is not rendered.
  final String Function(T) title;

  /// Function to extract description from fetched object of type T.
  final String Function(T) content;

  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);
  static const double _betweenPaddingValue = 9;
  static const double _verticalPaddingValue = 26;

  Widget _makeImage(T item) {
    final url = imageUrl(item);
    return url.startsWith('assets/')
        ? Image.asset(url)
        : Image.network(
            imageUrl(item),
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
            errorBuilder: (context, child, loadingProgress) => Center(
              child: Image.asset('assets/defaultMedia.png'),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: onFetch,
      defaultData: defaultData,
      hasData: hasData,
      loadingBuilder: (context, snapshot) => const RaProgressIndicator(),
      errorBuilder: (context) => const RaErrorPage(),
      builder: (context, item) => Padding(
        padding: RaPageConstraints.outerTextPagePadding,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: _verticalPaddingValue,
            bottom: context.playerPaddingValue,
          ),
          child: Column(
            spacing: _betweenPaddingValue,
            children: [
              AspectRatio(aspectRatio: 1, child: _makeImage(item)),
              if (title(item) == '')
                const SizedBox.shrink()
              else
                Container(
                  color: context.colors.backgroundDark,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: RaPageConstraints.textPageTitlePadding,
                      child: CustomPaddingHtmlWidget(
                        style: context.textStyles.textMedium.copyWith(
                          color: context.colors.backgroundLight,
                        ),
                        htmlContent: title(item),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: _textPadding,
                child: SelectableRegion(
                  selectionControls: MaterialTextSelectionControls(),
                  child: HtmlWidget(
                    content(item),
                    textStyle: context.textStyles.textSmallGreen.copyWith(
                      color: context.colors.backgroundDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:radioaktywne/components/ra_image.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Template for page with an image on top, a (optional)
/// title, and content text
class RaPageTemplate<T> extends StatelessWidget {
  const RaPageTemplate({
    super.key,
    required this.onFetch,
    required this.defaultData,
    required this.hasData,
    required this.itemBuilder,
  });

  /// Function to fetch the page data.
  final Future<T> Function() onFetch;

  /// Default data to be displayed before the page fully loads.
  final T defaultData;

  /// Function to determine if the fetched data is proper.
  final bool Function(T) hasData;

  /// Function that transforms fetched elements of type [T]
  /// into [RaPageTemplateItem]s to be displayed.
  final RaPageTemplateItem Function(T) itemBuilder;

  static const _textPadding = EdgeInsets.symmetric(horizontal: 7);
  static const double _betweenPaddingValue = 9;
  static const double _verticalPaddingValue = 26;

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: onFetch,
      defaultData: defaultData,
      hasData: hasData,
      loadingBuilder: (context, snapshot) => const RaProgressIndicator(),
      errorBuilder: (context) => const RaErrorPage(),
      builder: (context, item) {
        final currentItem = itemBuilder(item);
        return Padding(
          padding: RaPageConstraints.outerTextPagePadding,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: _verticalPaddingValue,
              bottom: context.playerPaddingValue,
            ),
            child: Column(
              spacing: _betweenPaddingValue,
              children: [
                if (currentItem.image != null)
                  AspectRatio(
                    aspectRatio: 1,
                    child: RaImage(imageUrl: currentItem.image!),
                  ),
                if (currentItem.title != null)
                  Container(
                    color: context.colors.backgroundDark,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: RaPageConstraints.textPageTitlePadding,
                        child: CustomPaddingHtmlWidget(
                          style: context.textStyles.textMediumLight,
                          htmlContent: currentItem.title!,
                        ),
                      ),
                    ),
                  ),
                if (currentItem.content != null)
                  Padding(
                    padding: _textPadding,
                    child: SelectableRegion(
                      selectionControls: MaterialTextSelectionControls(),
                      child: HtmlWidget(
                        currentItem.content!,
                        textStyle: context.textStyles.textSmallGreen.copyWith(
                          color: context.colors.backgroundDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RaPageTemplateItem {
  const RaPageTemplateItem({
    this.image,
    this.title,
    this.content,
  });

  final String? image;
  final String? title;
  final String? content;
}

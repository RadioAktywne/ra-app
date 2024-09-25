import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/themes.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';

/// Widget representing a horizontally swipeable card.
class SwipeableCard extends HookWidget {
  const SwipeableCard({
    super.key,
    required this.items,
    required this.shadowColor,
    this.header,
    this.isLoading = false,
    this.hasError = false,
  });

  /// Cards to be displayed by this widget.
  final Iterable<SwipeableCardItem> items;

  /// Color of the container behind this widget.
  final Color shadowColor;

  /// Optional header of the widget.
  final Widget? header;

  /// Optional bool indicating that data is still fetching
  final bool isLoading;

  /// Optional bool indicating that data couldn't be fetched
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final currentPage = useState(0);
    final pageController = usePageController();

    return ColorShadowedCard(
      shadowColor: shadowColor,
      header: Container(
        color: context.colors.backgroundDark,
        child: header,
      ),
      footer: !hasError && !isLoading ? Container(
        color: context.colors.backgroundDark,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
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
      ) : null,
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return const RaProgressIndicator();
          }
          if (hasError) {
            return const RaErrorPage();
          }
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  onPageChanged: (index) => currentPage.value = index,
                  itemBuilder: (context, index) {
                    final item = items.elementAt(index);
                    return GestureDetector(
                      onTap: item.onTap,
                      child: ImageWithOverlay(
                        thumbnailPath: item.thumbnailPath,
                        titleOverlay: HtmlWidget(item.title),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Info about a single card in the [SwipeableCard]
class SwipeableCardItem {
  SwipeableCardItem({
    required this.thumbnailPath,
    required this.title,
    this.onTap,
  });

  /// Path for image source
  final String thumbnailPath;

  /// Title to overlay on the bottom of the image
  final String title;

  /// Function used when widget is tapped. Usually used for navigation.
  final void Function()? onTap;
}

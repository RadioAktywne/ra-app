import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class SwipeableCardItem {
  SwipeableCardItem({
    required this.id,
    required this.thumbnailPath,
    required this.title,
    this.onTap,
  });

  final int id;
  final String thumbnailPath;
  final String title;
  final void Function()? onTap;
}

class SwipeableCard extends HookWidget {
  const SwipeableCard({
    super.key,
    required this.items,
    required this.isLoading,
    required this.shadowColor,
    this.header,
  });

  final Iterable<SwipeableCardItem> items;
  final bool isLoading;
  final Color shadowColor;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return ColorShadowedCard(
      shadowColor: shadowColor,
      header: Container(
        color: context.colors.backgroundDark,
        child: header,
      ),
      footer: Container(
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
      ),
      child: Stack(
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
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          color: context.colors.backgroundDarkSecondary,
                          child: isLoading
                              ? Image.asset(
                                  'assets/defaultMedia.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  item.thumbnailPath,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
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
                                child: HtmlWidget(item.title),
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
        ],
      ),
    );
  }
}

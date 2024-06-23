import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/color_shadowed_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class ColorShadowedCard2 extends StatelessWidget {
  const ColorShadowedCard2({
    super.key,
    required this.child,
    required this.shadowColor,
    this.header,
    this.footer,
    this.indicator,
  });

  final Widget child;
  final Color shadowColor;
  final Widget? header;
  final Widget? footer;
  final int? indicator;

  @override
  Widget build(BuildContext context) {
    return ColorShadowedWidget(
      shadowColor: shadowColor,
      child: Container(
        color: context.colors.backgroundDark,
        padding: const EdgeInsets.all(3),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: context.colors.backgroundDarkSecondary,
                  child: child,
                ),
              ],
            ),
            if (header != null)
              Container(
                color: context.colors.backgroundDark,
                child: header,
              ),
            if (footer != null)
              Positioned(
                bottom: indicator != null ? 8 : 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    color: context.colors.backgroundDark,
                    child: footer,
                  ),
                ),
              ),
              if (indicator != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: context.colors.backgroundDark,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: indicator == 0 ? context.colors.highlightGreen : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: indicator == 1 ? context.colors.highlightGreen : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: indicator == 2 ? context.colors.highlightGreen : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

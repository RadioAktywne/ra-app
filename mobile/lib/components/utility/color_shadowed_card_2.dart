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
  });

  final Widget child;
  final Color shadowColor;
  final Widget? header;
  final Widget? footer;
  
  @override
  Widget build(BuildContext context) {
    return ColorShadowedWidget(
      shadowColor: shadowColor,
      child: Container(
        color: context.colors.backgroundDark,
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (header != null)
                  Container(
                    color: context.colors.backgroundDark,
                    child: header,
                  ),
                Container(
                  color: context.colors.backgroundDarkSecondary,
                  child: child,
                ),
              ],
            ),
            if (footer != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    height: 60,
                    color: context.colors.backgroundDark,
                    child: footer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

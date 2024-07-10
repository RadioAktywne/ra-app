import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/color_shadowed_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class ColorShadowedCard extends StatelessWidget {
  const ColorShadowedCard({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (header != null)
              Container(
                color: context.colors.backgroundDark,
                child: header,
              ),
            Expanded(
              child: Container(
                color: context.colors.backgroundDarkSecondary,
                child: child,
              ),
            ),
            if (footer != null)
              Container(
                color: context.colors.backgroundDark,
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

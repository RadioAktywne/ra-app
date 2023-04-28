import 'package:flutter/material.dart';
import 'package:radioaktywne/components/color_shadowed_widget.dart';
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
          color: context.colors.background_dark,
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (header != null) Container(
                color: context.colors.background_dark,
                child: header,
              ),
              Container(
                color: context.colors.background_dark_secondary,
                child: child,
              ),
              if (footer != null) Container(
                color: context.colors.background_dark,
                child: footer,
              ),
            ],
          ),
        ),
    );
  }
}

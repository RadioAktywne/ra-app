import 'package:flutter/material.dart';
import 'package:radioaktywne/components/color_shadowed_widget.dart';

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
          color: const Color(0xFF302318), // TODO: Change this when color palette is added (ciemne ciemne)
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (header != null) Container(
                color: const Color(0xFF302318), // TODO: Change this when color palette is added (ciemne ciemne)
                child: header,
              ),
              Container(
                color: const Color(0xFF584E40), // TODO: Change this when color palette is added (ciemne jasne)
                child: child,
              ),
              if (footer != null) Container(
                color: const Color(0xFF302318), // TODO: Change this when color palette is added (ciemne ciemne)
                child: footer,
              ),
            ],
          ),
        ),
    );
  }
}

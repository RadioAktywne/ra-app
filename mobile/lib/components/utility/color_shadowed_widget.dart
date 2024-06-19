import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/shadowed_container.dart';

class ColorShadowedWidget extends StatelessWidget {
  const ColorShadowedWidget({
    super.key,
    required this.child,
    required this.shadowColor,
  });

  final Widget child;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Stack(
          children: [
            ShadowedContainer(
              margin: const EdgeInsets.only(
                left: 6,
                bottom: 6,
              ),
              backgroundColor: shadowColor,
            ),
            ShadowedContainer(
              margin: const EdgeInsets.only(
                right: 6,
                top: 6,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

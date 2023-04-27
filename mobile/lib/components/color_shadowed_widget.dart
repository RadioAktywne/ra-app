import 'package:flutter/material.dart';

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
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                left: 6,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                color: shadowColor,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            Container(
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

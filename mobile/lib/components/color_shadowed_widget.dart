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
            const ShadowedContainer(
              margin: EdgeInsets.only(
                left: 6,
                bottom: 6,
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

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.size,
    this.margin,
    this.padding,
    this.shape,
  });

  final Widget? child;

  final double? width;
  final double? height;
  final double? size;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? width,
      height: size ?? height,
      margin: margin,
      padding: padding,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

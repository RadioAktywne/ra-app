import 'package:flutter/material.dart';

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.size,
    this.shadowColor,
    this.margin,
    this.padding,
    this.shape,
  });

  final Widget? child;

  final double? width;
  final double? height;
  final double? size;
  final Color? shadowColor;
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
      decoration: BoxDecoration(
        color: shadowColor,
        boxShadow: const [
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

import 'package:flutter/material.dart';

/// A [Container] with a built-in shadow same as
/// in Figma to reduce boilerplate.
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
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double? size;
  final Color? shadowColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    assert(size == null || (width == null && height == null));
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

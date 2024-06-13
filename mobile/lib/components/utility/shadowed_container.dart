import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';

/// A [Container] with a built-in shadow same as
/// in Figma.
class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.size,
    this.backgroundColor,
    this.shadowColor,
    this.margin,
    this.padding,
    this.shape,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double? size;
  final Color? backgroundColor;
  final Color? shadowColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    assert(size == null || (width == null && height == null));
    return Container(
      width: size ?? width,
      height: size ?? height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape ?? BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? context.colors.blackShadow,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

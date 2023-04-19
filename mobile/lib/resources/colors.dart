import 'package:flutter/material.dart';

class RAColor extends Color {
  const RAColor._(super.value);

  RAColor._color(Color color) : super(color.value);

  RAColor alphaBlend(RAColor background) {
    return RAColor._color(Color.alphaBlend(this, background));
  }

  @override
  RAColor withOpacity(double opacity) {
    return RAColor._color(super.withOpacity(opacity));
  }
}

class RAColorTween extends Tween<RAColor?> {
  RAColorTween({super.begin, super.end});

  @override
  RAColor? lerp(double t) => RAColor._color(Color.lerp(begin, end, t)!);
}

abstract class RAColors {
  const RAColors._();

  static RAColors of(BuildContext context) =>
      RAColors.ofBrightness(Theme.of(context).brightness);

  static RAColors ofBrightness(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return const _ColorsLight();
      case Brightness.dark:
        return const _ColorsLight();
    }
  }

  // TODO: add project colors
  RAColor get primary;
}

class _ColorsLight extends RAColors {
  const _ColorsLight() : super._();
  @override
  RAColor get primary => const RAColor._(0xFFFFFFFF);
}

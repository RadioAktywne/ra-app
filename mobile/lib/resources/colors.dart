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

  RAColor get background_light;
  RAColor get background_light_secondary;
  RAColor get background_dark;
  RAColor get background_dark_secondary;

  RAColor get highlight_red;
  RAColor get highlight_blue;
  RAColor get highlight_yellow;
  RAColor get highlight_green;
  RAColor get highlight_purple;
  RAColor get highlight_orange;
  RAColor get highlight_magenta;
}

class _ColorsLight extends RAColors {
  const _ColorsLight() : super._();
  @override
  // backgrounds
  RAColor get background_light => const RAColor._(0xFFFFF4DB);
  RAColor get background_light_secondary => const RAColor._(0xFFEADFC8);
  RAColor get background_dark => const RAColor._(0xFF302318);
  RAColor get background_dark_secondary => const RAColor._(0xFF584E40);

  // highlights
  RAColor get highlight_red => const RAColor._(0xFFE15B58);
  RAColor get highlight_blue => const RAColor._(0xFF7690B6);
  RAColor get highlight_yellow => const RAColor._(0xFFDED93D);
  RAColor get highlight_green => const RAColor._(0xFF6DB79B);
  RAColor get highlight_purple => const RAColor._(0xFFD198FE);
  RAColor get highlight_orange => const RAColor._(0xFFFFA573);
  RAColor get highlight_magenta => const RAColor._(0xFFFD95FF);
}

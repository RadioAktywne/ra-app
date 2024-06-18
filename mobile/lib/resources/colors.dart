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
        return const ColorsLight();
      case Brightness.dark:
        return const ColorsLight();
    }
  }

  RAColor get backgroundLight;
  RAColor get backgroundLightSecondary;
  RAColor get backgroundDark;
  RAColor get backgroundDarkSecondary;

  RAColor get highlightRed;
  RAColor get highlightBlue;
  RAColor get highlightYellow;
  RAColor get highlightGreen;
  RAColor get highlightPurple;
  RAColor get highlightOrange;
  RAColor get highlightMagenta;

  RAColor get drawerBackgroundOverlay;
  RAColor get blackShadow;
}

class ColorsLight extends RAColors {
  const ColorsLight() : super._();
  // backgrounds
  @override
  RAColor get backgroundLight => const RAColor._(0xFFFFF4DB);
  @override
  RAColor get backgroundLightSecondary => const RAColor._(0xFFEADFC8);
  @override
  RAColor get backgroundDark => const RAColor._(0xFF302318);
  @override
  RAColor get backgroundDarkSecondary => const RAColor._(0xFF584E40);

  // highlights
  @override
  RAColor get highlightRed => const RAColor._(0xFFE15B58);
  @override
  RAColor get highlightBlue => const RAColor._(0xFF7690B6);
  @override
  RAColor get highlightYellow => const RAColor._(0xFFDED93D);
  @override
  RAColor get highlightGreen => const RAColor._(0xFF6DB79B);
  @override
  RAColor get highlightPurple => const RAColor._(0xFFD198FE);
  @override
  RAColor get highlightOrange => const RAColor._(0xFFFFA573);
  @override
  RAColor get highlightMagenta => const RAColor._(0xFFFD95FF);

  // Special color to match background color from Figma when opening drawer
  // while not making everything else look so yellow at the same time.
  // Approved by RA on Discord.
  @override
  RAColor get drawerBackgroundOverlay => const RAColor._(0x5A130900);

  @override
  RAColor get blackShadow => const RAColor._(0x60000000);
}

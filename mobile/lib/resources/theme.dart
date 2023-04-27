import 'package:flutter/material.dart';
import 'package:radioaktywne/resources/colors.dart';

class RATheme {
  static ThemeData light(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).background_dark,
      secondary: RAColors.of(context).background_dark_secondary,
      lighterText: RAColors.of(context).highlight_green,
      darkerText: RAColors.of(context).highlight_green,
      surface: RAColors.of(context).background_dark_secondary,
      background: RAColors.of(context).background_light,
      error: RAColors.of(context).highlight_red,
      onError: RAColors.of(context).highlight_green,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).background_dark,
      secondary: RAColors.of(context).background_dark_secondary,
      lighterText: RAColors.of(context).highlight_green,
      darkerText: RAColors.of(context).highlight_green,
      surface: RAColors.of(context).background_dark_secondary,
      background: RAColors.of(context).background_light,
      error: RAColors.of(context).highlight_red,
      onError: RAColors.of(context).highlight_green,
      brightness: Brightness.light,
    );
  }

  static ThemeData _build({
    required BuildContext context,
    required Brightness brightness,
    required RAColor primary,
    required RAColor secondary,
    required RAColor lighterText,
    required RAColor darkerText,
    required RAColor surface,
    required RAColor background,
    required RAColor error,
    required RAColor onError,
  }) {
    return ThemeData.from(
      colorScheme: ColorScheme(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        error: error,
        onPrimary: lighterText,
        onSecondary: darkerText,
        onSurface: darkerText,
        onBackground: darkerText,
        onError: onError,
        brightness: brightness,
      ),
    ).copyWith(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: RAColors.of(context).background_light,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

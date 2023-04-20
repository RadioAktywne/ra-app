import 'package:flutter/material.dart';
import 'package:radioaktywne/resources/colors.dart';

// TODO: use proper colors
class RATheme {
  static ThemeData light(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).primary,
      secondary: RAColors.of(context).primary,
      lighterText: RAColors.of(context).primary,
      darkerText: RAColors.of(context).primary,
      surface: RAColors.of(context).primary,
      background: RAColors.of(context).primary,
      error: RAColors.of(context).primary,
      onError: RAColors.of(context).primary,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).primary,
      secondary: RAColors.of(context).primary,
      lighterText: RAColors.of(context).primary,
      darkerText: RAColors.of(context).primary,
      surface: RAColors.of(context).primary,
      background: RAColors.of(context).primary,
      error: RAColors.of(context).primary,
      onError: RAColors.of(context).primary,
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
          color: RAColors.of(context).primary,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

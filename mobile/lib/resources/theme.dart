// support deprecated "background" and "onBackground" values
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:radioaktywne/resources/colors.dart';

class RATheme {
  static ThemeData light(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).backgroundDark,
      secondary: RAColors.of(context).backgroundDarkSecondary,
      lighterText: RAColors.of(context).highlightGreen,
      darkerText: RAColors.of(context).highlightGreen,
      surface: RAColors.of(context).backgroundDarkSecondary,
      background: RAColors.of(context).backgroundLight,
      error: RAColors.of(context).highlightRed,
      onError: RAColors.of(context).highlightGreen,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark(BuildContext context) {
    return _build(
      context: context,
      primary: RAColors.of(context).backgroundDark,
      secondary: RAColors.of(context).backgroundDarkSecondary,
      lighterText: RAColors.of(context).highlightGreen,
      darkerText: RAColors.of(context).highlightGreen,
      surface: RAColors.of(context).backgroundDarkSecondary,
      background: RAColors.of(context).backgroundLight,
      error: RAColors.of(context).highlightRed,
      onError: RAColors.of(context).highlightGreen,
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
          color: RAColors.of(context).backgroundLight,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

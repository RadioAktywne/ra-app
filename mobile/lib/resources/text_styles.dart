import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/themes.dart';

class RATextStyles {
  const RATextStyles(this.context);

  final BuildContext context;

  TextStyle get polibudzka => TextStyle(
        fontSize: 18,
        fontFamily: 'Radio Canada',
        fontWeight: FontWeight.normal,
        color: context.colors.highlightGreen,
      );

  TextStyle get textPlayer => TextStyle(
        fontSize: 24,
        fontFamily: 'Arial',
        fontWeight: FontWeight.bold,
        color: context.colors.highlightGreen,
      );

  TextStyle get textMedium => TextStyle(
        fontSize: 16,
        fontFamily: 'Arial',
        fontWeight: FontWeight.bold,
        color: context.colors.highlightGreen,
      );

  TextStyle get textSmallGreen => TextStyle(
        fontSize: 12,
        fontFamily: 'Arial',
        fontWeight: FontWeight.bold,
        color: context.colors.highlightGreen,
      );

  TextStyle get textSmallWhite =>
      textSmallGreen.copyWith(color: context.colors.backgroundLight);

  TextStyle get textSmallGreenNormal =>
      textSmallGreen.copyWith(fontWeight: FontWeight.normal);

  TextStyle get textBurgerMenuItem =>
      textMedium.copyWith(color: context.colors.backgroundLight);
  TextStyle get textBurgerMenuItemSelected =>
      textMedium.copyWith(color: context.colors.backgroundDark);
}

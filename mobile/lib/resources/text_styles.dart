import 'package:flutter/cupertino.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class RATextStyles {
  const RATextStyles(this.context);

  final BuildContext context;

  TextStyle get polibudzka => TextStyle(
        fontSize: 18,
        fontFamily: 'RadikalWUT',
        fontWeight: FontWeight.bold,
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

  TextStyle get textSmall => TextStyle(
        fontSize: 12,
        fontFamily: 'Arial',
        fontWeight: FontWeight.bold,
        color: context.colors.highlightGreen,
      );

  TextStyle get textNormal => textSmall.copyWith(fontWeight: FontWeight.normal);

  TextStyle get textBurgerMenuItem =>
      textMedium.copyWith(color: context.colors.backgroundLight);
  TextStyle get textBurgerMenuItemSelected =>
      textMedium.copyWith(color: context.colors.backgroundDark);
}

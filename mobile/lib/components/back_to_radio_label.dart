import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class BackToRadioLabel extends StatelessWidget {
  const BackToRadioLabel({
    super.key,
    required this.height,
    required this.width,
    required this.text,
  });

  final double height;
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundDark,
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(
            text,
            style: TextStyle(
              color: context.colors.highlightGreen,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        // ),
      );
  }
}

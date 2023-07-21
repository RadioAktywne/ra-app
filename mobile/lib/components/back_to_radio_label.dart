import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackToRadioLabel extends StatelessWidget {
  const BackToRadioLabel({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.mainColor,
    required this.textColor,
  });

  final double height;
  final double width;
  final String text;
  final Color mainColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        // ),
      );
  }
}

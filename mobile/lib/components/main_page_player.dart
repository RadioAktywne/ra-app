import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainPagePlayer extends StatelessWidget {
  const MainPagePlayer({
    super.key,
    required this.height,
    this.iconPath,
    required this.bottomSize,
    required this.mainColor,
    required this.accentColor,
    required this.title,
    required this.imageHeight,
    this.paddingVertical,
    this.paddingHorizontal,
  });

  final double height;
  final String? iconPath;
  final double bottomSize;
  final Color mainColor;
  final Color accentColor;
  final String title;
  final double imageHeight;
  final int? paddingVertical;
  final int? paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
     child: Row(
      children: [
        Padding(padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal?.toDouble() ?? 0,
            vertical: paddingVertical?.toDouble() ?? 0,
          ),
          child: Row(
          children: [
            if (iconPath != null) SvgPicture.asset(
              height: imageHeight,
              iconPath!,
              ) else Container(),
            ],
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Text(
          title,
          style: TextStyle(
            color: accentColor,
            fontSize: 24,
          ),
        ),
      ],
    // ),
      ),
    );
  }
}

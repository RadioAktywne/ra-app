import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radioaktywne/components/progress_bar.dart';
import 'back_to_radio_label.dart';

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
    required this.onClick,
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
  final void Function() onClick;

  Widget _getIcon(String? iconPath) {
  if (iconPath != null) {
    return SvgPicture.asset(
    height: imageHeight,
    iconPath,
    );
  } else {
    return Container();
  }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 180), //.symmetric(horizontal: 8),
          child: BackToRadioLabel(
            height: 22,
            width: 133,
            text: 'Wróć do radia',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            color: mainColor,
            child: Row(
             children: [
               Padding(padding: EdgeInsets.symmetric(
                   horizontal: paddingHorizontal?.toDouble() ?? 0,
                   vertical: paddingVertical?.toDouble() ?? 0,
                 ),
                 child: Row(
                 children: [
                   GestureDetector(
                       onTap: onClick,
                       child: _getIcon(iconPath),
                     ),
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
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ],
             ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: RaProgressBar(totalLength: Duration(milliseconds: 50000)),
        ),
      ],
    );
  }
}

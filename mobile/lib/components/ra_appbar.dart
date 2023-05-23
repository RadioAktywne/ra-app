import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RaAppBar({
    super.key,
    required this.height,
    required this.icon,
    required this.bottomSize,
    required this.mainColor,
    required this.accentColor,
    this.iconButton,
    required this.text,
    this.iconPath,
    this.titlePadding,
    required this.imageHeight,
});

  final int height;
  final Icon icon;
  final int bottomSize;
  final Color mainColor;
  final Color accentColor;
  final IconButton? iconButton;
  final String text;
  final String? iconPath;
  final EdgeInsets? titlePadding;
  final int imageHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height.toDouble(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: accentColor,
          height: bottomSize.toDouble(),
        ),
      ),
      actions: <Widget>[
        iconButton!
      ],
      backgroundColor: mainColor,
      title: Padding(
        padding: titlePadding!,
        child: Row(
          children: [
            SvgPicture.asset(
              height: imageHeight.toDouble(),
              iconPath!,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              text,
              style: TextStyle(
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height.toDouble());
  }
}

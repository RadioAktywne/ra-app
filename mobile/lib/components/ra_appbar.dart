import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/ra_routes.dart';

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

  final double height;
  final Icon icon;
  final double bottomSize;
  final Color mainColor;
  final Color accentColor;
  final IconButton? iconButton;
  final String text;
  final String? iconPath;
  final EdgeInsets? titlePadding;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainColor,
      ),
    );
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: accentColor,
          height: bottomSize,
        ),
      ),
      actions: <Widget>[iconButton ?? Container()],
      backgroundColor: mainColor,
      elevation: 0,
      title: Padding(
        padding:
            titlePadding ?? const EdgeInsets.only(left: 4, top: 8, bottom: 16),
        child: GestureDetector(
          onTap: () => context.go(RaRoutes.home),
          child: Row(
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  height: imageHeight,
                  iconPath!,
                )
              else
                Container(),
              const SizedBox(
                width: 14,
              ),
              Text(
                text,
                style: context.textStyles.polibudzka,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }
}

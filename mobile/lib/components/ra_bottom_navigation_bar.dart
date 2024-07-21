import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/extensions/themes.dart';
import 'package:radioaktywne/router/ra_routes.dart';

/// Represents aplication's bottom navigation bar.
class RaBottomNavigationBar extends StatelessWidget {
  const RaBottomNavigationBar({
    super.key,
    required this.currentPath,
    this.borderWidth = 5,
    this.onNavigate,
  });

  /// Name of the current page provided by
  /// the [GoRouter]'s state.
  final String currentPath;

  /// The width of this widget's green border.
  final double borderWidth;

  /// Optional function to be called on every
  /// navigation to a route __different__ than
  /// the current one.
  final void Function()? onNavigate;

  // Leaving this as a reminder...
  // static const labels = <String>['home', 'mic', 'album', 'article'];
  // static const widths = <double>[30, 21, 32.5, 27];
  // static const heights = <double>[26, 28.5, 32.5, 27];

  static const _itemInfo = [
    (
      pagePath: RaRoutes.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      iconSize: 30.0,
    ),
    (
      pagePath: RaRoutes.recordings,
      icon: Icons.mic_none_outlined,
      activeIcon: Icons.mic,
      iconSize: 28.5,
    ),
    (
      pagePath: RaRoutes.albumOfTheWeek,
      icon: Icons.album_outlined,
      activeIcon: Icons.album,
      iconSize: 32.5,
    ),
    (
      pagePath: RaRoutes.articles,
      icon: Icons.article_outlined,
      activeIcon: Icons.article,
      iconSize: 27.0,
    ),
  ];

  List<Widget> _makeList() {
    return _itemInfo
        .map(
          (item) => RaBottomNavigationBarItem(
            activeIcon: Icon(item.activeIcon),
            icon: Icon(item.icon),
            iconSize: item.iconSize,
            pagePath: item.pagePath,
            isSelected: item.pagePath == currentPath,
            onNavigate: onNavigate,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundDark,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: borderWidth),
          color: context.colors.highlightGreen,
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5),
            color: context.colors.backgroundDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _makeList(),
            ),
          ),
        ),
      ),
    );
  }
}

class RaBottomNavigationBarItem extends StatelessWidget {
  const RaBottomNavigationBarItem({
    super.key,
    required this.activeIcon,
    required this.icon,
    required this.iconSize,
    required this.pagePath,
    required this.isSelected,
    this.onNavigate,
  });

  final Icon activeIcon;
  final Icon icon;
  final double iconSize;
  final String pagePath;
  final bool isSelected;
  final void Function()? onNavigate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isSelected) {
          onNavigate?.call();
        }
        context.go(pagePath);
      },
      icon: isSelected ? activeIcon : icon,
      iconSize: iconSize,
      color: context.colors.highlightGreen,
    );
  }
}

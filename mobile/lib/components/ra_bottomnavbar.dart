import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/ra_routes.dart';

// TODO: Refactor into widget that determines
// TODO: selected icon by current route path
/// Represents aplication's bottom navigation bar.
class RaBottomNavigationBar extends HookWidget {
  const RaBottomNavigationBar({
    super.key,
    required this.selectedPageIndex,
    this.onTap,
    this.startIconIndex = 0,
    this.borderWidth = 5.0,
  });

  /// Index of the currently selected page.
  final int selectedPageIndex;

  final void Function()? onTap;

  /// Specifies the index of the icon
  /// that should be selected at first.
  ///
  /// This has to be a value greater than
  /// or equal to 0 and less than the number
  /// of icons (4).
  final int startIconIndex;

  /// Specifies the width of the green border
  /// of the widget (5.0 on default).
  final double borderWidth;

  // Leaving this as a reminder...
  // static const labels = <String>['home', 'mic', 'album', 'article'];
  // static const widths = <double>[30, 21, 32.5, 27];
  // static const heights = <double>[26, 28.5, 32.5, 27];

  static const _navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined, size: 30),
      activeIcon: Icon(Icons.home, size: 30),
      label: RaRoutes.home,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mic_none_outlined, size: 28.5),
      activeIcon: Icon(Icons.mic, size: 28.5),
      label: RaRoutes.recordings,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.album_outlined, size: 32.5),
      activeIcon: Icon(Icons.album, size: 32.5),
      label: RaRoutes.albumOfTheWeek,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined, size: 27),
      activeIcon: Icon(Icons.article, size: 27),
      label: RaRoutes.articles,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    assert(startIconIndex >= 0 && startIconIndex < 4);
    // final currentIndex = useState(startIconIndex);
    return Container(
      padding: EdgeInsets.only(top: borderWidth),
      color: context.colors.highlightGreen,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: context.colors.backgroundDark,
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.colors.backgroundDark,
          selectedItemColor: context.colors.highlightGreen,
          unselectedItemColor: context.colors.highlightGreen,
          currentIndex: selectedPageIndex,
          onTap: (index) {
            onTap?.call();
            context.go(_navigationItems[index].label!);
          },
          items: _navigationItems,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class RaBottomNavigationBar extends StatelessWidget {
  const RaBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.borderWidth = 5,
  });

  final int currentIndex;
  final double borderWidth;

  // ? Leaving this as a reminder...
  // static const labels = <String>['home', 'mic', 'album', 'article'];
  // static const widths = <double>[30, 21, 32.5, 27];
  // static const heights = <double>[26, 28.5, 32.5, 27];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: borderWidth),
      height: 50,
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
          currentIndex: currentIndex,
          onTap: (index) {
            // TODO: Implement navigation
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              activeIcon: Icon(Icons.home, size: 30),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none_outlined, size: 28.5),
              activeIcon: Icon(Icons.mic, size: 28.5),
              label: 'mic',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.album_outlined, size: 32.5),
              activeIcon: Icon(Icons.album, size: 32.5),
              label: 'album',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, size: 27),
              activeIcon: Icon(Icons.article, size: 27),
              label: 'article',
            ),
          ],
        ),
      ),
    );
  }
}

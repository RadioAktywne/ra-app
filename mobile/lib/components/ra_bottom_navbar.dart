import 'package:flutter/material.dart';

import 'package:radioaktywne/resources/assets.gen.dart';
import 'package:radioaktywne/resources/colors.dart';

class RaBottomNavigationBar extends StatelessWidget {
  const RaBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  // icons
  static final home = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/home.svg').svg(),
  );
  static final homeOutline = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/home_outline.svg').svg(),
  );
  static final mic = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/mic.svg').svg(),
  );
  static final micOutline = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/mic_outline.svg').svg(),
  );
  static final album = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/album.svg').svg(),
  );
  static final albumOutline = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/album_outline.svg').svg(),
  );
  static final article = SizedBox(
    width: 35,
    height: 35,
    child: const SvgGenImage('assets/ra_bottom_navbar/article.svg').svg(),
  );
  static final articleOutline = SizedBox(
    width: 35,
    height: 35,
    child:
        const SvgGenImage('assets/ra_bottom_navbar/article_outline.svg').svg(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 79,
      color: RAColors.of(context).highlightGreen,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: RAColors.of(context).backgroundDark,
        selectedItemColor: RAColors.of(context).highlightGreen,
        unselectedItemColor: RAColors.of(context).highlightGreen,
        currentIndex: currentIndex,
        onTap: (index) {
          // todo: navigation
          switch (index) {
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: homeOutline,
            activeIcon: home,
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: micOutline,
            activeIcon: mic,
            label: 'mic',
          ),
          BottomNavigationBarItem(
            icon: albumOutline,
            activeIcon: album,
            label: 'album',
          ),
          BottomNavigationBarItem(
            icon: articleOutline,
            activeIcon: article,
            label: 'article',
          ),
        ],
      ),
    );
  }
}

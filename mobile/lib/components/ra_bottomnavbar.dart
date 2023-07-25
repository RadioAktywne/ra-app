import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

import 'package:radioaktywne/resources/assets.gen.dart';
import 'package:radioaktywne/resources/colors.dart';

class RaBottomNavigationBar extends StatelessWidget {
  const RaBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  static final labels = [
    'home',
    'mic',
    'album',
    'article',
  ];

  SizedBox _loadIconWithName(String name) {
    return SizedBox(
      width: 35,
      height: 35,
      child: SvgGenImage('assets/icons/$name.svg').svg(),
    );
  }

  List<BottomNavigationBarItem> _makeList(List<String> labels) {
    final list = <BottomNavigationBarItem>[];
    for (final label in labels) {
      list.add(
        BottomNavigationBarItem(
          icon: _loadIconWithName('${label}_outline'),
          activeIcon: _loadIconWithName(label),
          label: label,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      height: 79,
      color: RAColors.of(context).highlightGreen,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.colors.backgroundDark,
        selectedItemColor: context.colors.highlightGreen,
        unselectedItemColor: context.colors.highlightGreen,
        currentIndex: currentIndex,
        onTap: (index) {
          // TODO: Implement navigation
        },
        items: _makeList(labels),
      ),
    );
  }
}

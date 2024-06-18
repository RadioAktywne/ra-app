import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

// TODO: Refactor into widget that determines
// TODO: selected icon by current route path
/// Represents the burger menu contained
/// in the right side drawer.
class RaBurgerMenu extends HookWidget {
  const RaBurgerMenu({
    super.key,
    required this.navigationItems,
    required this.selectedIndex,
    this.borderWidth = 5.0,
    this.onItemClicked,
  });

  /// Map of navigation links for the [GoRouter]
  /// with their corresponding names.
  final Map<String, String> navigationItems;

  final void Function()? onItemClicked;

  /// Burger menu border width
  final double borderWidth;

  /// Index of the currently selected page
  final int selectedIndex;

  List<RaBurgerMenuItem> _makeList(BuildContext context) {
    final colors = <Color>[
      context.colors.highlightRed,
      context.colors.highlightYellow,
      context.colors.highlightGreen,
      context.colors.highlightBlue,
    ];

    return navigationItems.entries.mapIndexed((index, entry) {
      final MapEntry(key: pagePath, value: pageTitle) = entry;

      return RaBurgerMenuItem(
        title: pageTitle,
        color: colors[index % colors.length],
        onPressed: () {
          onItemClicked?.call();
          context.go(pagePath);
        },
        chosen: index == selectedIndex,
      );
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.highlightGreen,
      padding: EdgeInsets.only(left: borderWidth),
      width: 226,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: context.colors.backgroundDark,
        child: ListView(
          children: _makeList(context),
        ),
      ),
    );
  }
}

/// Represents a single item in the burger menu
class RaBurgerMenuItem extends StatelessWidget {
  const RaBurgerMenuItem({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    required this.chosen,
  });

  final String title;
  final Color color;
  final void Function()? onPressed;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      color: context.colors.backgroundDark,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(color.withAlpha(50)),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: WidgetStateProperty.all(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: context.textStyles.textBurgerMenuItem,
            ),
            const SizedBox(
              width: 10,
            ),
            AnimatedContainer(
              width: chosen ? 18 : 6,
              height: 38,
              color: color,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/router/ra_routes.dart';

/// Represents the burger menu contained
/// in the right side drawer.
class RaBurgerMenu extends HookWidget {
  const RaBurgerMenu({
    super.key,
    required this.currentPath,
    this.borderWidth = 5.0,
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

  static const _pageTitles = [
    (RaRoutes.home, 'Radio Aktywne'),
    (RaRoutes.recordings, 'Nagrania'),
    (RaRoutes.albumOfTheWeek, 'Płyta tygodnia'),
    (RaRoutes.articles, 'Publicystyka'),
    (RaRoutes.radioPeople, 'Radiowcy'),
    (RaRoutes.ramowka, 'Ramówka'),
    (RaRoutes.broadcasts, 'Audycje'),
    (RaRoutes.about, 'O nas'),
  ];

  List<RaBurgerMenuItem> _makeList(BuildContext context) => List.generate(
        _pageTitles.length,
        (index) {
          final (pagePath, pageTitle) = _pageTitles[index];

          return RaBurgerMenuItem(
            title: pageTitle,
            color: context.shadowColor(index),
            onPressed: () {
              if (pagePath != currentPath) {
                onNavigate?.call();
              }
              context.go(pagePath);
            },
            isSelected: pagePath == currentPath,
          );
        },
        growable: false,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.highlightGreen,
      padding: EdgeInsets.only(left: borderWidth),
      width: 226,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: context.colors.backgroundDark,
        shape: Border.all(style: BorderStyle.none),
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
    required this.isSelected,
  });

  final String title;
  final Color color;
  final void Function()? onPressed;
  final bool isSelected;

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
              width: isSelected ? 18 : 6,
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

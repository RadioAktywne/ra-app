import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// Represents the burger menu contained
/// in the right side drawer.
class RaBurgerMenu extends HookWidget {
  const RaBurgerMenu({
    super.key,
    required this.titles,
    required this.links,
    this.borderWidth = 5.0,
    this.selectedIndex = 0,
  });

  /// Titles for menu items
  final List<String> titles;

  /// Navigation links
  final List<void Function()> links;

  /// Burger menu border width
  final double borderWidth;

  /// Index of the currently selected page
  final int selectedIndex;

  List<RaBurgerMenuItem> _makeList(
    BuildContext context,
    List<String> titles,
    List<void Function()> links,
    ValueNotifier<int> selectedIndex,
  ) {
    assert(titles.length == links.length);

    final list = <RaBurgerMenuItem>[];
    final colors = <Color>[
      context.colors.highlightRed,
      context.colors.highlightYellow,
      context.colors.highlightGreen,
      context.colors.highlightBlue,
    ];

    titles.forEachIndexed((index, title) {
      list.add(
        RaBurgerMenuItem(
          title: title,
          color: colors[index % colors.length],
          onPressed: () {
            selectedIndex.value = index;
            links[index]();
          },
          chosen: selectedIndex.value == index,
        ),
      );
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final selected = useState(selectedIndex);

    return Container(
      color: context.colors.highlightGreen,
      padding: EdgeInsets.only(left: borderWidth),
      width: 226,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: context.colors.backgroundDark,
        child: ListView(
          children: _makeList(context, titles, links, selected),
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

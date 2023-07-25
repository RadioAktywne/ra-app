import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class RaBurgerMenu extends StatelessWidget {
  const RaBurgerMenu({
    super.key,
    required this.titles,
    required this.links,
    this.borderWidth = 8.0,
  });

  // ? Item titles
  final List<String> titles;
  // ? Navigation links
  final List<void Function()> links;
  // ? Burger menu border width
  final double borderWidth;

  List<RaBurgerMenuItem> _makeList(
    BuildContext context,
    List<String> titles,
    List<void Function()> links,
  ) {
    if (titles.length != links.length) {
      throw Exception(
        'List of titles and list of predicates should have the same length!',
      );
    }
    final list = <RaBurgerMenuItem>[];
    final colors = [
      context.colors.highlightRed,
      context.colors.highlightYellow,
      context.colors.highlightGreen,
      context.colors.highlightBlue,
    ];

    for (var i = 0; i < titles.length; i++) {
      list.add(
        RaBurgerMenuItem(
          title: titles[i],
          color: colors[i % colors.length],
          onPressed: links[i],
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    assert(titles.length == links.length);
    return Container(
      color: context.colors.highlightGreen,
      padding: EdgeInsets.only(left: borderWidth),
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        shadowColor: Colors.transparent,
        backgroundColor: context.colors.backgroundDark,
        child: ListView(
          children: _makeList(context, titles, links),
        ),
      ),
    );
  }
}

class RaBurgerMenuItem extends StatelessWidget {
  const RaBurgerMenuItem({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  final String title;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(
            bottom: 5,
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: context.textStyles.textSidebar,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 6,
            height: 38,
            color: color,
          ),
        ],
      ),
    );
  }
  // final String routeName;
}

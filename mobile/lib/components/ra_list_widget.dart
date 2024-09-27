import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// A scrollable list widget with alternating-colored items.
class RaListWidget extends StatelessWidget {
  const RaListWidget({
    super.key,
    required this.items,
    required this.rows,
    this.rowHeight = RaPageConstraints.ramowkaListRowHeight,
    this.scrollPhysics,
  });

  /// List of items to be displayed in each row
  final List<Widget> items;

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  final ScrollPhysics? scrollPhysics;

  /// Calculate current color from current index in the list
  Color _color(BuildContext context, int index) => index.isEven
      ? context.colors.backgroundDarkSecondary
      : context.colors.backgroundDark.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final height = rows * rowHeight;
    return SizedBox(
      height: height,
      child: ListView.builder(
        physics: scrollPhysics,
        itemCount: min(items.length, rows),
        itemBuilder: (context, index) => _RaListWidgetItem(
          item: items[index],
          color: _color(context, index),
          rowHeight: rowHeight,
        ),
      ),
    );
  }
}

/// Represents a single [RaListWidget] entry.
class _RaListWidgetItem extends StatelessWidget {
  const _RaListWidgetItem({
    required this.item,
    required this.color,
    required this.rowHeight,
  });

  /// The item to be displayed in the row
  final Widget item;

  /// This item's background color
  final Color color;

  /// Single row's height
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rowHeight,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: item,
      ),
    );
  }
}

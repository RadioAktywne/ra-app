import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';

class RaDropdownIcon extends StatelessWidget {
  const RaDropdownIcon({super.key, required this.state, this.size = 20});
  final RaDropdownIconState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      switch (state) {
        RaDropdownIconState.closed => Icons.keyboard_arrow_up,
        RaDropdownIconState.opened => Icons.keyboard_arrow_down,
      },
      color: context.colors.highlightGreen,
      size: size,
    );
  }
}

enum RaDropdownIconState { opened, closed }

import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';

class RaSplash extends StatelessWidget {
  const RaSplash({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: context.colors.highlightGreen.withOpacity(0.3),
        radius: 25,
        child: child,
      ),
    );
  }
}

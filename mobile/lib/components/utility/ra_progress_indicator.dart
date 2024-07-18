import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/themes.dart';

/// Progress indicator with predefined style to match
/// the app theme and the Platform.
class RaProgressIndicator extends StatelessWidget {
  const RaProgressIndicator({
    super.key,
    this.size = 40.0,
  });

  /// Size of the indicator
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: context.colors.highlightGreen,
                strokeWidth: 5,
              )
            : CupertinoActivityIndicator(
                color: context.colors.highlightGreen,
                radius: size / 2,
              ),
      ),
    );
  }
}

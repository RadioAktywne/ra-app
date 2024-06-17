import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

class RaProgressIndicator extends StatelessWidget {
  const RaProgressIndicator({
    super.key,
    this.size = 40.0,
  });

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

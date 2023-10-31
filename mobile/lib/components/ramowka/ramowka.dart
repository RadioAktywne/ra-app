import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radioaktywne/components/color_shadowed_card.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/extensions/extensions.dart';

/// Widget representing Ramówka
///
/// Consists of a [ColorShadowedCard] with a header and
/// a list of entries in Ramowka.
class Ramowka extends StatelessWidget {
  const Ramowka({
    super.key,
    this.dataSource,
    this.timeout = const Duration(seconds: 7),
  });

  /// Asynchronous source of data in the widget.
  ///
  /// On default, the data is pulled from the radioaktywne.pl api.
  /// If specified, the data will be pulled from the specified source.
  final Future<void>? dataSource;

  /// Timeout for the fetching function.
  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: ColorShadowedCard(
        shadowColor: context.colors.highlightBlue,
        header: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: SizedBox(
            height: 31,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // TODO: (optional) nagivation to Ramowka page
                onTap: () {},
                highlightColor: Colors.transparent,
                splashColor: context.colors.highlightGreen.withOpacity(0.3),
                radius: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      // TODO: nagivation to Ramowka page
                      onTap: () {},
                      child: Text(
                        'Ramówka',
                        style: context.textStyles.textMedium,
                      ),
                    ),
                    GestureDetector(
                      // TODO: nagivation to Ramowka page
                      onTap: () {},
                      child: Icon(
                        Icons.menu,
                        size: 28,
                        color: context.colors.highlightGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        child: RamowkaList(
          timeout: timeout,
          dDataSource: dataSource,
        ),
      ),
    );
  }
}

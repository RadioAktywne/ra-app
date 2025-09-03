import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/router/ra_routes.dart';

/// Widget representing Ramówka
///
/// Consists of a [ColorShadowedCard] with a header and
/// a [RamowkaList] of Ramowka entries.
class RamowkaWidget extends StatelessWidget {
  const RamowkaWidget({
    super.key,
    this.timeout = const Duration(seconds: 7),
    this.shadowColor,
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  /// Shadow color for the card.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final defaultShadowColor = context.colors.highlightBlue;

    return ColorShadowedCard(
      shadowColor: shadowColor ?? defaultShadowColor,
      header: Padding(
        padding: const EdgeInsets.only(
          left: RaPageConstraints.headerTextPaddingLeft,
        ),
        child: SizedBox(
          height: 31,
          child: RaSplash(
            onPressed: () => context.push(RaRoutes.ramowka),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.push(RaRoutes.ramowka),
                  child: Text(
                    context.l10n.ramowka,
                    style: context.textStyles.textMediumGreen,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(RaRoutes.ramowka),
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
      child: RamowkaList(
        timeout: timeout,
      ),
    );
  }
}

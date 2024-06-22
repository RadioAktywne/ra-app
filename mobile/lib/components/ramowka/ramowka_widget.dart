import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/router/ra_routes.dart';

/// Widget representing Ramówka
///
/// Consists of a [ColorShadowedCard] with a header and
/// a [RamowkaList] of Ramowka entries.
class RamowkaWidget extends StatelessWidget {
  const RamowkaWidget({
    super.key,
    this.timeout = const Duration(seconds: 7),
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    return ColorShadowedCard(
      shadowColor: context.colors.highlightBlue,
      header: Padding(
        padding: const EdgeInsets.only(left: 3),
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
                    style: context.textStyles.textMedium,
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

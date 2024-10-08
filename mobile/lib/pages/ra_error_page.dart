import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Simple error page displayed when the page data cannot be loaded.
class RaErrorPage extends StatelessWidget {
  const RaErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            maxHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: RaPageConstraints.outerTextPagePadding,
              child: Text(
                context.l10n.dataLoadError,
                style: context.textStyles.textSmallGreen,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

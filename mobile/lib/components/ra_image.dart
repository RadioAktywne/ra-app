import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';

class RaImage extends StatelessWidget {
  const RaImage({
    super.key,
    required this.imageUrl,
  });

  /// network link, `file://` or even `assets/`
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl.startsWith('assets/')
        ? Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          )
        : Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? FittedBox(
                        fit: BoxFit.fitWidth,
                        clipBehavior: Clip.hardEdge,
                        child: child,
                      )
                    : Container(
                        color: context.colors.backgroundDarkSecondary,
                        child: const RaProgressIndicator(),
                      ),
            errorBuilder: (context, child, loadingProgress) => Center(
              child: Image.asset('assets/defaultMedia.png'),
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/themes.dart';

/// Widget representing an image with overlaid text on the bottom of the image.
class ImageWithOverlay extends StatelessWidget {
  const ImageWithOverlay({
    super.key,
    required this.thumbnailPath,
    this.child,
    this.titleOverlay,
    this.titleOverlayPadding = const EdgeInsets.all(4),
    this.imageBuilder = Image.network,
  });

  /// Child widget to display centered above the image, BUT ABOVE TITLE OVERLAY.
  final Widget? child;

  /// Network or local path to the image.
  final String thumbnailPath;

  /// Function used to display the image (used mainly to be able to switch
  /// between network and local images). Defaults to network image.
  final Image Function(String) imageBuilder;

  /// Title to display over the image, on the bottom.
  final Widget? titleOverlay;

  /// lets optionally change padding around the title.
  final EdgeInsets titleOverlayPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color: context.colors.backgroundDarkSecondary,
            child: Image(
              image: imageBuilder(thumbnailPath).image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/defaultMedia.png',
                fit: BoxFit.cover,
              ),
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress != null
                      ? const Center(
                          child: RaProgressIndicator(),
                        )
                      : child,
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: child ?? const SizedBox.shrink(),
              ),
              if (titleOverlay != null)
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    color: context.colors.backgroundDark,
                    child: DefaultTextStyle(
                      style: context.textStyles.textSmallGreen,
                      child: Padding(
                        padding: titleOverlayPadding,
                        child: titleOverlay,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

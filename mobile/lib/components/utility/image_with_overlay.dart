import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// Widget representing an image with overlaid text on the bottom of the image.
class ImageWithOverlay extends StatelessWidget {
  const ImageWithOverlay({
    super.key,
    this.child,
    required this.thumbnailPath,
    this.imageConstructor = Image.network,
    this.titleOverlay,
    required this.isLoading,
    this.titleOverlayPadding = const EdgeInsets.all(4),
  });

  /// Child widget to display centered above the image, BUT ABOVE TITLE OVERLAY.
  final Widget? child;

  /// Network or local path to the image.
  final String thumbnailPath;

  /// Function used to display the image (used mainly to be able to switch
  /// between network and local images). Defaults to network image.
  final Image Function(String, {BoxFit fit}) imageConstructor;

  /// Title to display over the image, on the bottom.
  final Widget? titleOverlay;

  /// Boolean value used to display default image when image hasn't loaded yet.
  final bool isLoading;

  /// lets optionally change padding around the title.
  final EdgeInsets titleOverlayPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color: context.colors.backgroundDarkSecondary,
            child: isLoading
                ? Image.asset(
                    'assets/defaultMedia.png',
                    fit: BoxFit.cover,
                  )
                : imageConstructor(
                    thumbnailPath,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // if (child != null)
        //   Positioned.fill(
        //     child: child!,
        //   ),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: child ?? Container(),
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

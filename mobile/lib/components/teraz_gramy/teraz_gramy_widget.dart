import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// TODO: This is still a dummy widget, needs implementing fetching logic
/// Widget representing what's currently played on the radio
///
/// Consists of a [ColorShadowedCard] with an image, icon ant text overlay.
class TerazGramyWidget extends StatelessWidget {
  const TerazGramyWidget({
    super.key,
    this.shadowColor,
  });

  /// Shadow color for the card.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final defaultShadowColor = context.colors.highlightRed;

    return ColorShadowedCard(
      shadowColor: shadowColor ?? defaultShadowColor,
      child: ImageWithOverlay(
        imageBuilder: Image.asset,
        thumbnailPath: 'assets/teraz_gramy_background.webp',
        titleOverlay: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Teraz gramy \n',
                style: context.textStyles.textPlayer.copyWith(
                  color: context.colors.highlightGreen,
                ),
              ),
              TextSpan(
                text: 'RDS streamu',
                // TODO: Place for the stream RDS
                style: context.textStyles.textMedium.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        titleOverlayPadding: const EdgeInsets.all(8),
        // TODO: This is just a dummy mock, needs major work
        child: RaPlayButton(
          onPressed: () {},
          size: 100,
          audioProcessingState: AudioProcessingState.completed,
        ),
      ),
    );
  }
}

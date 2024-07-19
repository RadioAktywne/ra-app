import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/extensions/build_context.dart';

import '../../state/audio_handler_cubit.dart';
import '../radio_player/radio_player_widget.dart';

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
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
        builder: (context, audioHandler) {
    final defaultShadowColor = context.colors.highlightRed;

    return ColorShadowedCard(
      shadowColor: shadowColor ?? defaultShadowColor,
      child: ImageWithOverlay(
        imageBuilder: Image.asset,
        thumbnailPath: 'assets/teraz_gramy_background.webp',
        titleOverlay: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: switch (audioHandler) {
            null =>
            [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Teraz gramy \n',
                      style: context.textStyles.textPlayer.copyWith(
                        color: context.colors.highlightGreen,
                      ),
                    ),
                    TextSpan(
                      text: 'No stream title',
                      style: context.textStyles.textMedium.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            _ =>
            [RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Teraz gramy',
                    style: context.textStyles.textPlayer.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                  ),
                ],
              ),
            ),
              StreamTitle(
                audioHandler: audioHandler,
                width: MediaQuery.of(context).size.width,
                style: context.textStyles.textMedium.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          },
        ),
        titleOverlayPadding: const EdgeInsets.all(8),
        // TODO: This is just a dummy mock, needs major work
        child: Row(
    children: switch (audioHandler) {
          null => [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: RaPlayButton(
                onPressed: () {},
                size: 100,
                audioProcessingState: AudioProcessingState.loading,
              ),
            ),
        ],
          _ => [
            StreamPlayButton(
              audioHandler: audioHandler,
              buttonSize: 100,
              padding: const EdgeInsets.symmetric(horizontal: 100),
            ),
          ],
        },
      ),
      ),
    );
  },
    );
  }
}

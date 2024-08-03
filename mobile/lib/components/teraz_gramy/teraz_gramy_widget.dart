import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_widget.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

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

  static const double _buttonSize = 100;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
      builder: (context, audioHandler) {
        return ColorShadowedCard(
          shadowColor: shadowColor ?? context.colors.highlightRed,
          child: ImageWithOverlay(
            imageBuilder: Image.asset,
            thumbnailPath: 'assets/teraz_gramy_background.webp',
            titleOverlay: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.nowPlaying,
                  style: context.textStyles.textPlayer.copyWith(
                    color: context.colors.highlightGreen,
                  ),
                ),
                PlayerTitle(
                  audioHandler: audioHandler,
                  width: MediaQuery.of(context).size.width,
                  textStyle:
                      context.textStyles.textMedium.copyWith(height: 1.5),
                ),
              ],
            ),
            titleOverlayPadding: const EdgeInsets.all(8),
            child: Center(
              child: PlayerPlayButton(
                audioHandler: audioHandler,
                size: _buttonSize,
                padding: const EdgeInsets.symmetric(horizontal: _buttonSize),
              ),
            ),
          ),
        );
      },
    );
  }
}

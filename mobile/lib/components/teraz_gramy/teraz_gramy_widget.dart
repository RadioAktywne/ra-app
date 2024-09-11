import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
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
        return ValueListenableBuilder<MediaKind>(
          valueListenable: audioHandler.mediaKind,
          builder: (context, mediaKind, _) {
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
                    ValueListenableBuilder<String?>(
                      valueListenable: audioHandler.streamTitle,
                      builder: (context, value, _) {
                        final title = value ?? context.l10n.noStreamTitle;
                        return RaPlayerTitle(
                          width: MediaQuery.of(context).size.width,
                          title: title,
                          textStyle: context.textStyles.textMedium
                              .copyWith(height: 1.5),
                        );
                      },
                    ),
                  ],
                ),
                titleOverlayPadding: const EdgeInsets.all(8),
                child: Center(
                  child: StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final isRadio = mediaKind == MediaKind.radio;
                      return RaPlayButton(
                        size: _buttonSize,
                        onPressed: () => isRadio
                            ? state?.processingState ==
                                    AudioProcessingState.ready
                                ? audioHandler.stop()
                                : audioHandler.play()
                            : audioHandler.playMediaItem(
                                RaPlayerConstants.radioMediaItem,
                              ),
                        audioProcessingState: isRadio
                            ? state?.processingState ??
                                AudioProcessingState.idle
                            : AudioProcessingState.idle,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

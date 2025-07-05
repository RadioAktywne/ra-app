import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/ra_player/ra_player_widget.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/image_with_overlay.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// Widget representing what's currently played on the radio.
///
/// Consists of a [ColorShadowedCard] with an image, icon and text overlay.
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
                ValueListenableBuilder<String?>(
                  valueListenable: audioHandler.streamTitle,
                  builder: (context, streamTitle, _) {
                    final title = streamTitle ?? context.l10n.noStreamTitle;
                    return RaPlayerTitle(
                      width: MediaQuery.sizeOf(context).width,
                      title: title,
                      textStyle:
                          context.textStyles.textMedium.copyWith(height: 1.5),
                    );
                  },
                ),
              ],
            ),
            titleOverlayPadding: RaPageConstraints.textPageTitlePadding,
            child: Center(
              child: ValueListenableBuilder<MediaKind>(
                valueListenable: audioHandler.mediaKind,
                builder: (context, mediaKind, _) {
                  return StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, snapshot) {
                      final state = snapshot.data?.processingState ??
                          AudioProcessingState.idle;
                      return StreamBuilder<bool>(
                        stream: audioHandler.playing,
                        builder: (context, snapshot) {
                          final playing = snapshot.data ?? false;
                          return RaPlayButton(
                            size: _buttonSize,
                            onPressed: () => switch (mediaKind) {
                              MediaKind.radio => playing
                                  ? audioHandler.stop()
                                  : audioHandler.play(),
                              MediaKind.recording =>
                                audioHandler.playMediaItem(radioMediaItem)
                            },
                            audioProcessingState: switch (mediaKind) {
                              MediaKind.radio => state,
                              MediaKind.recording => AudioProcessingState.idle,
                            },
                            playing: playing,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

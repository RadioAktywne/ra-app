import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/radio_player/audio_player_handler.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';
import 'package:text_scroll/text_scroll.dart';

/// The radio player with scrolling stream title
/// and a [RaPlayButton].
///
/// Should be positioned at the bottom of the screen,
/// "attached" to the navigation bar
/// (in accordance to Figma).
class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final Duration animationDuration;

  /// Measurements from Figma
  static const double buttonSize = 37;
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 14);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
      builder: (context, audioHandler) {
        return StreamBuilder<MediaItem?>(
          stream: audioHandler?.mediaItem,
          builder: (context, snapshot) {
            final mediaKind = snapshot
                .data?.extras?[AudioPlayerConstants.mediaKind] as MediaKind?;
            return AnimatedContainer(
              duration: animationDuration,
              width: MediaQuery.of(context).size.width,
              height: switch (mediaKind) {
                null || MediaKind.radio => RaPageConstraints.radioPlayerHeight,
                MediaKind.recording =>
                  2.5 * RaPageConstraints.radioPlayerHeight,
              },
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: _SeekBar(
                      audioHandler: audioHandler,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: animationDuration,
                    bottom: switch (mediaKind) {
                      null || MediaKind.radio => 0,
                      MediaKind.recording =>
                        RaPageConstraints.radioPlayerHeight * 2,
                    },
                    child: _BackButton(
                      audioHandler: audioHandler,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: animationDuration,
                    bottom: switch (mediaKind) {
                      null || MediaKind.radio => 0,
                      MediaKind.recording =>
                        RaPageConstraints.radioPlayerHeight,
                    },
                    child: _RadioPlayer(audioHandler: audioHandler),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RadioPlayer extends StatelessWidget {
  const _RadioPlayer({required this.audioHandler});

  final AudioHandler? audioHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RaPageConstraints.radioPlayerHeight,
      width: MediaQuery.of(context).size.width,
      color: context.colors.backgroundDarkSecondary,
      child: Row(
        children: switch (audioHandler) {
          null => [
              Padding(
                padding: RadioPlayerWidget.horizontalPadding,
                child: RaPlayButton(
                  onPressed:
                      () {}, // maybe display a message like: "Radio player couldn't be loaded"?
                  size: RadioPlayerWidget.buttonSize,
                  audioProcessingState: AudioProcessingState.loading,
                ),
              ),
              Text(
                context.l10n.noStreamTitle,
                style: context.textStyles.textPlayer,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          _ => [
              _StreamPlayButton(
                audioHandler: audioHandler!,
              ),
              _StreamTitle(
                audioHandler: audioHandler!,
              ),

              /// A seek bar. It could be helpful when playing recordings.
              // StreamBuilder<MediaState>(
              //   stream: _mediaStateStream,
              //   builder: (context, snapshot) {
              //     final mediaState = snapshot.data;
              //     return SeekBar(
              //       duration:
              //           mediaState?.mediaItem?.duration ?? Duration.zero,
              //       position: mediaState?.position ?? Duration.zero,
              //       onChangeEnd: (newPosition) {
              //         audioHandler.seek(newPosition);
              //       },
              //       bufferedPosition: Duration.zero,
              //     );
              //   },
              // ),
            ],
        },
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.audioHandler});

  final AudioHandler? audioHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      color: context.colors.backgroundDark,
      height: RaPageConstraints.radioPlayerHeight / 2,
      child: GestureDetector(
        onTap: () =>
            audioHandler?.playMediaItem(AudioPlayerConstants.radioMediaItem),
        child: Text('Wróć do radia', style: context.textStyles.textSmallGreen),
      ),
    );
  }
}

class _SeekBar extends HookWidget {
  const _SeekBar({required this.audioHandler});

  final AudioHandler? audioHandler;

  @override
  Widget build(BuildContext context) {
    final slider = useState<double>(0);
    return StreamBuilder<MediaItem?>(
      stream: audioHandler?.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return Container(
          width: MediaQuery.of(context).size.width,
          height: RaPageConstraints.radioPlayerHeight,
          color: context.colors.backgroundDark,
          child: Center(
            child: Slider(
              allowedInteraction: SliderInteraction.slideThumb,
              activeColor: context.colors.highlightGreen,
              // secondaryActiveColor: context.colors.highlightRed,
              inactiveColor: context.colors.backgroundLight,
              thumbColor: context.colors.highlightRed,
              max: (mediaItem?.duration ?? Duration.zero).inSeconds.toDouble(),
              value: slider.value,
              onChanged: (position) => slider.value = position,
              onChangeEnd: (position) =>
                  audioHandler?.seek(Duration(seconds: position.round())),
            ),
          ),
        );
      },
    );
  }
}

class MediaState {
  const MediaState({required this.mediaItem, required this.position});

  final MediaItem? mediaItem;
  final Duration position;
}

enum RaPlayerKind {
  radioPlayer,
  recordingPlayer;
}

/// The [RaPlayButton] controlling the radio stream.
class _StreamPlayButton extends StatelessWidget {
  const _StreamPlayButton({
    required this.audioHandler,
  });

  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: RadioPlayerWidget.horizontalPadding,
      child: StreamBuilder<AudioProcessingState>(
        stream: audioHandler.playbackState
            .map((state) => state.processingState)
            .distinct(),
        builder: (context, snapshot) {
          final audioProcessingState =
              snapshot.data ?? AudioProcessingState.idle;
          return StreamBuilder<bool>(
            stream: audioHandler.playbackState
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;
              return RaPlayButton(
                size: RadioPlayerWidget.buttonSize,
                onPressed: playing ? audioHandler.stop : audioHandler.play,
                audioProcessingState: audioProcessingState,
              );
            },
          );
        },
      ),
    );
  }
}

/// The display of the radio stream title.
class _StreamTitle extends StatelessWidget {
  const _StreamTitle({
    required this.audioHandler,
  });

  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return SizedBox(
          width: MediaQuery.of(context).size.width / 1.4,
          child: TextScroll(
            (mediaItem?.title != null && mediaItem!.title.isNotEmpty == true)
                ? mediaItem.title
                : 'No stream title',
            velocity: const Velocity(
              pixelsPerSecond: Offset(17, 0),
            ),
            pauseBetween: const Duration(milliseconds: 2500),
            intervalSpaces: 6,
            selectable: true,
            style: context.textStyles.textPlayer,
          ),
        );
      },
    );
  }
}

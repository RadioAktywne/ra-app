import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<AudioHandlerCubit, AudioPlayerHandler>(
      builder: (context, audioHandler) {
        return StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            final mediaKind = snapshot
                .data?.extras?[AudioPlayerConstants.mediaKind] as MediaKind?;
            return AnimatedContainer(
              duration: animationDuration,
              width: MediaQuery.of(context).size.width,
              height: switch (mediaKind) {
                null || MediaKind.radio => RaPageConstraints.radioPlayerHeight,
                MediaKind.recording => RaPageConstraints.recordingPlayerHeight,
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
                    left: 12,
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

  final AudioPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RaPageConstraints.radioPlayerHeight,
      width: MediaQuery.of(context).size.width,
      color: context.colors.backgroundDarkSecondary,
      child: Row(
        children: [
          _PlayButton(
            audioHandler: audioHandler,
          ),
          _StreamTitle(
            audioHandler: audioHandler,
          ),
        ],
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
      width: (MediaQuery.of(context).size.width -
              2 * RaPageConstraints.pagePaddingValue) /
          3,
      height: RaPageConstraints.radioPlayerHeight / 2,
      color: context.colors.backgroundDark,
      child: GestureDetector(
        onTap: () =>
            audioHandler?.playMediaItem(AudioPlayerConstants.radioMediaItem),
        child: Center(
          child:
              Text('Wróć do radia', style: context.textStyles.textSmallGreen),
        ),
      ),
    );
  }
}

class SeekBarData {
  const SeekBarData({
    required this.position,
    required this.mediaItem,
  });

  final Duration position;
  final MediaItem mediaItem;
}

class _SeekBar extends HookWidget {
  const _SeekBar({required this.audioHandler});

  final AudioPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -
          2 * RaPageConstraints.pagePaddingValue,
      height: RaPageConstraints.radioPlayerHeight,
      color: context.colors.backgroundDark,
      child: Center(
        child: ValueListenableBuilder<ProgressBarState>(
          valueListenable: audioHandler.progressNotifier,
          builder: (_, value, __) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RaPageConstraints.pagePaddingValue,
              ),
              child: ProgressBar(
                progress: value.current,
                total: value.total,
                buffered: value.buffered,
                thumbColor: context.colors.highlightRed,
                thumbRadius: 5,
                thumbGlowRadius: 15,
                bufferedBarColor: context.colors.backgroundLightSecondary,
                baseBarColor: context.colors.backgroundLight,
                progressBarColor: context.colors.highlightGreen,
                thumbCanPaintOutsideBar: false,
                timeLabelLocation: TimeLabelLocation.none,
                onSeek: audioHandler.seek,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The [RaPlayButton] controlling the radio stream.
class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.audioHandler,
  });

  final AudioPlayerHandler audioHandler;

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
                : 'No stream title', // TODO: change for RadioAktywne
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

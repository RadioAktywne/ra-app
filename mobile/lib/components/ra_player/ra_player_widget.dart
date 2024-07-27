import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';
import 'package:text_scroll/text_scroll.dart';

/// The player widget for radio and recordings.
///
/// It changes its state based on [MediaKind]
/// passed as an extra in [RaPlayerHandler]'s [MediaItem].
///
/// Should be positioned at the bottom of the screen,
/// "attached" to the navigation bar
/// (in accordance to Figma).
class RaPlayerWidget extends StatelessWidget {
  const RaPlayerWidget({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
      builder: (context, audioHandler) {
        return StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            final mediaKind = snapshot
                .data?.extras?[RaPlayerConstants.mediaKind] as MediaKind?;
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
                    child: _Player(audioHandler: audioHandler),
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

class _SeekBarData {
  const _SeekBarData({
    required this.position,
    required this.mediaItem,
  });

  final Duration position;
  final MediaItem mediaItem;
}

class _SeekBar extends HookWidget {
  const _SeekBar({required this.audioHandler});

  final RaPlayerHandler audioHandler;

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
          builder: (context, value, child) {
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.audioHandler});

  final RaPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width -
              2 * RaPageConstraints.pagePaddingValue) /
          3,
      height: RaPageConstraints.radioPlayerHeight / 2,
      color: context.colors.backgroundDark,
      child: GestureDetector(
        onTap: () async =>
            audioHandler.playMediaItem(RaPlayerConstants.radioMediaItem),
        child: Center(
          child: Text(
            context.l10n.backToRadio,
            style: context.textStyles.textSmallGreen,
          ),
        ),
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.audioHandler});

  final RaPlayerHandler audioHandler;

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

/// The [RaPlayButton] controlling the radio stream.
class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.audioHandler,
  });

  final RaPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: StreamBuilder<AudioProcessingState>(
        stream: audioHandler.playbackState
            .map((state) => state.processingState)
            .distinct(),
        builder: (context, snapshot) {
          final audioProcessingState =
              snapshot.data ?? AudioProcessingState.idle;
          if (audioProcessingState == AudioProcessingState.completed) {
            audioHandler
              ..seek(Duration.zero)
              ..stop();
          }
          return StreamBuilder<bool>(
            stream: audioHandler.playbackState
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;
              return RaPlayButton(
                size: 37,
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

  final RaPlayerHandler audioHandler;

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
            velocity: const Velocity(pixelsPerSecond: Offset(17, 0)),
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

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:text_scroll/text_scroll.dart';

/// The player widget for radio and recordings.
///
/// It changes its state based on [RaPlayerHandler]'s
/// [MediaKind].
///
/// Should be positioned at the bottom of the screen,
/// "attached" to the navigation bar.
class RaPlayerWidget extends StatelessWidget {
  const RaPlayerWidget({
    super.key,
    required this.audioHandler,
    required this.mediaKind,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final RaPlayerHandler audioHandler;
  final MediaKind mediaKind;
  final Duration animationDuration;

  static const double _playerSize = 37;
  static const double _thumbRadius = 5;
  static const double _thumbGlowRadius = 15;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            MediaKind.radio => 0,
            MediaKind.recording => RaPageConstraints.radioPlayerHeight * 2,
          },
          left: 12,
          child: _BackButton(
            audioHandler: audioHandler,
          ),
        ),
        AnimatedPositioned(
          duration: animationDuration,
          bottom: switch (mediaKind) {
            MediaKind.radio => 0,
            MediaKind.recording => RaPageConstraints.radioPlayerHeight,
          },
          child: _Player(audioHandler: audioHandler),
        ),
      ],
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

  double _calculateSeekBarWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const pagePadding = RaPageConstraints.pagePaddingValue;
    return screenWidth - 2 * pagePadding;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _calculateSeekBarWidth(context),
      height: RaPageConstraints.radioPlayerHeight,
      color: context.colors.backgroundDark,
      child: Center(
        child: ValueListenableBuilder<ProgressBarState>(
          valueListenable: audioHandler.progress,
          builder: (context, progress, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RaPageConstraints.pagePaddingValue,
              ),
              child: ProgressBar(
                progress: progress.current,
                total: progress.total,
                buffered: progress.buffered,
                thumbColor: context.colors.highlightRed,
                thumbRadius: RaPlayerWidget._thumbRadius,
                thumbGlowRadius: RaPlayerWidget._thumbGlowRadius,
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

  double _calculateButtonWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = RaPageConstraints.pagePaddingValue * 2;
    return (screenWidth - padding) / 3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _calculateButtonWidth(context),
      height: RaPageConstraints.radioPlayerHeight / 2,
      color: context.colors.backgroundDark,
      child: GestureDetector(
        onTap: () => audioHandler.playMediaItem(radioMediaItem),
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
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerPlayButton(
            audioHandler: audioHandler,
            size: RaPlayerWidget._playerSize,
          ),
          _PlayerTitle(
            audioHandler: audioHandler,
            width: MediaQuery.of(context).size.width / 1.65,
          ),
          RaSplash(
            // TODO: go to player page (with an animation - "blow up" the container!)
            onPressed: () => audioHandler.playerKind.value = PlayerKind.page,
            child: const Padding(
              padding: EdgeInsets.zero,
              child:
                  RaDropdownIcon(state: RaDropdownIconState.closed, size: 44),
            ),
          ),
        ],
      ),
    );
  }
}

/// The [RaPlayButton] controlling the radio stream.
class PlayerPlayButton extends StatelessWidget {
  const PlayerPlayButton({
    super.key,
    required this.audioHandler,
    required this.size,
    this.padding = const EdgeInsets.symmetric(
      horizontal: RaPageConstraints.pagePaddingValue,
    ),
  });

  final RaPlayerHandler audioHandler;
  final double size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
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
            stream: audioHandler.playing,
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;
              return ValueListenableBuilder<MediaKind>(
                valueListenable: audioHandler.mediaKind,
                builder: (context, mediaKind, _) {
                  return RaPlayButton(
                    size: size,
                    onPressed: playing
                        ? switch (mediaKind) {
                            MediaKind.radio => audioHandler.stop,
                            MediaKind.recording => audioHandler.pause,
                          }
                        : audioHandler.play,
                    playing: playing,
                    audioProcessingState: audioProcessingState,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// The display of the radio stream title.
class _PlayerTitle extends StatelessWidget {
  const _PlayerTitle({
    required this.audioHandler,
    required this.width,
  });

  final RaPlayerHandler audioHandler;
  final double width;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        final title = mediaItem?.title ?? context.l10n.noStreamTitle;
        return RaPlayerTitle(
          title: title.isNotEmpty ? title : context.l10n.noStreamTitle,
          width: width,
        );
      },
    );
  }
}

class RaPlayerTitle extends StatelessWidget {
  const RaPlayerTitle({
    super.key,
    required this.title,
    required this.width,
    this.textStyle,
  });

  final String title;
  final double width;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextScroll(
        title,
        velocity: const Velocity(pixelsPerSecond: Offset(17, 0)),
        pauseBetween: const Duration(milliseconds: 2500),
        intervalSpaces: 6,
        selectable: true,
        style: textStyle ?? context.textStyles.textPlayer,
      ),
    );
  }
}

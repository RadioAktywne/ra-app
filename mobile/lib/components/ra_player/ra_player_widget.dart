import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
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
    this.animationDuration = const Duration(milliseconds: 400),
  });

  final RaPlayerHandler audioHandler;
  final Duration animationDuration;

  static const double _playerSize = 37;
  static const double _thumbRadius = 5;
  static const double _thumbGlowRadius = 15;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: audioHandler.playerKind,
      builder: (context, playerKind, _) {
        return ValueListenableBuilder(
          valueListenable: audioHandler.mediaKind,
          builder: (context, mediaKind, _) {
            return AnimatedContainer(
              duration: animationDuration,
              color: switch (playerKind) {
                PlayerKind.widget => Colors.transparent,
                PlayerKind.page => context.colors.backgroundDark,
              },
              margin: switch (playerKind) {
                PlayerKind.page => EdgeInsets.zero,
                PlayerKind.widget => RaPageConstraints.outerWidgetPagePadding,
              },
              height: switch (playerKind) {
                PlayerKind.widget => switch (mediaKind) {
                    MediaKind.radio => RaPageConstraints.radioPlayerHeight,
                    MediaKind.recording =>
                      RaPageConstraints.recordingPlayerHeight,
                  },
                PlayerKind.page => MediaQuery.sizeOf(context).height,
              },
              child: Wrap(
                spacing: 15,
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _PlayerWidget(
                    animationDuration: animationDuration,
                    audioHandler: audioHandler,
                    mediaKind: mediaKind,
                    playerKind: playerKind,
                  ),
                  AnimatedContainer(
                    duration: animationDuration,
                    height: switch (playerKind) {
                      PlayerKind.widget => 1,
                      PlayerKind.page =>
                        MediaQuery.sizeOf(context).height - 200,
                    },
                    padding: RaPageConstraints.outerWidgetPagePadding * 2,
                    child: AnimatedOpacity(
                      duration: animationDuration,
                      opacity: switch (playerKind) {
                        PlayerKind.widget => 0.0,
                        PlayerKind.page => 1.0
                      },
                      child: _RadioPlayerPage(
                        animationDuration: animationDuration,
                        audioHandler: audioHandler,
                        playerKind: playerKind,
                      ),
                    ),
                  ),
                  _BackToMainPageButton(
                    audioHandler: audioHandler,
                    animationDuration: animationDuration,
                    playerKind: playerKind,
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

class _RadioPlayerPage extends StatelessWidget {
  const _RadioPlayerPage({
    required this.animationDuration,
    required this.audioHandler,
    required this.playerKind,
  });

  final Duration animationDuration;
  final RaPlayerHandler audioHandler;
  final PlayerKind playerKind;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: AspectRatio(
            aspectRatio: 1.3 / 1,
            child: PlayerPlayButton(
              audioHandler: audioHandler,
              size: 130,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.l10n.nowPlaying}:',
              style: context.textStyles.textMedium.copyWith(
                color: context.colors.backgroundLight,
                fontWeight: FontWeight.normal,
              ),
            ),
            _PlayerTitle(
              audioHandler: audioHandler,
              width: MediaQuery.sizeOf(context).width,
              textStyle: context.textStyles.textMedium.copyWith(
                color: context.colors.backgroundLight,
              ),
              intervalSpaces: 10,
            ),
          ],
        ),
        const SizedBox(height: 70),
        Text(
          '${context.l10n.ramowka}:',
          style: context.textStyles.textMedium.copyWith(
            color: context.colors.backgroundLight,
            fontWeight: FontWeight.normal,
          ),
        ),
        const RamowkaList(
          rows: 10,
          scrollPhysics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

class _BackToMainPageButton extends StatelessWidget {
  const _BackToMainPageButton({
    required this.audioHandler,
    required this.animationDuration,
    required this.playerKind,
  });

  final RaPlayerHandler audioHandler;
  final Duration animationDuration;
  final PlayerKind playerKind;

  @override
  Widget build(BuildContext context) {
    return RaSplash(
      onPressed: audioHandler.changePlayerKind,
      child: AnimatedContainer(
        duration: animationDuration,
        height: switch (playerKind) {
          PlayerKind.widget => 0,
          PlayerKind.page => 40,
        },
        color: context.colors.backgroundDarkSecondary,
        child: Center(
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.backToMainPage, // '⮌' symbol not working
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.highlightGreen,
                ),
              ),
              FittedBox(
                child: Icon(
                  Icons.keyboard_return_outlined,
                  color: context.colors.highlightGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    required this.animationDuration,
    required this.audioHandler,
    required this.playerKind,
    required this.mediaKind,
  });

  final Duration animationDuration;
  final RaPlayerHandler audioHandler;
  final PlayerKind playerKind;
  final MediaKind mediaKind;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: animationDuration,
          height: switch (mediaKind) {
            MediaKind.radio => 0,
            MediaKind.recording => switch (playerKind) {
                PlayerKind.widget => RaPageConstraints.radioPlayerHeight / 2,
                PlayerKind.page => 0
              },
          },
          margin: EdgeInsets.only(
            right: MediaQuery.sizeOf(context).width - 180,
          ),
          child: _BackToRadioButton(audioHandler: audioHandler),
        ),
        AnimatedContainer(
          duration: animationDuration,
          height: RaPageConstraints.radioPlayerHeight,
          padding: switch (playerKind) {
            PlayerKind.page => RaPageConstraints.outerWidgetPagePadding,
            PlayerKind.widget => EdgeInsets.zero,
          },
          width: MediaQuery.sizeOf(context).width,
          color: switch (playerKind) {
            PlayerKind.widget => context.colors.backgroundDarkSecondary,
            PlayerKind.page => context.colors.backgroundDark,
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  switch (playerKind) {
                    PlayerKind.widget => PlayerPlayButton(
                        audioHandler: audioHandler,
                        size: RaPlayerWidget._playerSize,
                      ),
                    PlayerKind.page => const SizedBox(width: 12),
                  },
                  _PlayerTitle(
                    audioHandler: audioHandler,
                    width: MediaQuery.sizeOf(context).width / 1.65,
                    overrideTitle: switch (playerKind) {
                      PlayerKind.widget => null,
                      PlayerKind.page =>
                        context.mediaKindToString(audioHandler.mediaKind.value),
                    },
                  ),
                ],
              ),
              RaSplash(
                onPressed: audioHandler.changePlayerKind,
                child: RaDropdownIcon(audioHandler: audioHandler),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: animationDuration,
          height: switch (mediaKind) {
            MediaKind.radio => 0,
            MediaKind.recording => switch (playerKind) {
                PlayerKind.widget => RaPageConstraints.radioPlayerHeight,
                PlayerKind.page => 0
              },
          },
          width: MediaQuery.sizeOf(context).width,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: switch (mediaKind) {
              MediaKind.radio => 0.0,
              MediaKind.recording => switch (playerKind) {
                  PlayerKind.widget => 1.0,
                  PlayerKind.page => 0
                },
            },
            child: _RecordingSeekBar(audioHandler: audioHandler),
          ),
        ),
      ],
    );
  }
}

class _RecordingSeekBar extends HookWidget {
  const _RecordingSeekBar({required this.audioHandler});

  final RaPlayerHandler audioHandler;

  double _calculateSeekBarWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const pagePadding = RaPageConstraints.pagePaddingValue;
    return screenWidth - 2 * pagePadding;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _calculateSeekBarWidth(context),
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
                ));
          },
        ),
      ),
    );
  }
}

class _BackToRadioButton extends StatelessWidget {
  const _BackToRadioButton({required this.audioHandler});

  final RaPlayerHandler audioHandler;

  double _calculateButtonWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
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
      width: MediaQuery.sizeOf(context).width,
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
            width: MediaQuery.sizeOf(context).width / 1.65,
          ),
          RaSplash(
            // TODO: go to player page (with an animation - "blow up" the container!)
            onPressed: audioHandler.changePlayerKind,
            child: const Padding(
              padding: EdgeInsets.zero,
              child: Placeholder(),
              //  RaDropdownIcon(state: RaDropdownIconState.closed),
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
    this.overrideTitle,
    this.textStyle,
    this.intervalSpaces,
  });

  final RaPlayerHandler audioHandler;
  final double width;
  final String? overrideTitle;
  final TextStyle? textStyle;
  final int? intervalSpaces;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        final title =
            overrideTitle ?? mediaItem?.title ?? context.l10n.noStreamTitle;
        return RaPlayerTitle(
          title: title.isNotEmpty ? title : context.l10n.noStreamTitle,
          textStyle: textStyle,
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
    this.intervalSpaces,
  });

  final String title;
  final double width;
  final TextStyle? textStyle;
  final int? intervalSpaces;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextScroll(
        title,
        velocity: const Velocity(pixelsPerSecond: Offset(17, 0)),
        pauseBetween: const Duration(milliseconds: 2500),
        intervalSpaces: intervalSpaces ?? 6,
        style: textStyle ?? context.textStyles.textPlayer,
      ),
    );
  }
}

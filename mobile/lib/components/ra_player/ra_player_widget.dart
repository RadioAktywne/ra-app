import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_image.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_splash.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';
import 'package:text_scroll/text_scroll.dart';

/// The player widget for radio and recordings.
/// Also the player page.
///
/// It changes its state based on [RaPlayerHandler]'s
/// [MediaKind] and [PlayerKind].
///
/// Should be positioned at the bottom of the screen,
/// "attached" to the navigation bar.
class RaPlayerWidget extends StatelessWidget {
  const RaPlayerWidget({
    super.key,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  final Duration animationDuration;

  static const double _playerButtonSize = 37;
  static const double _seekBarThumbRadius = 5;
  static const double _seekBarThumbGlowRadius = 15;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, RaPlayerHandler>(
        builder: (context, audioHandler) {
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
                        PlayerKind.widget => 0,
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
                        child: switch (mediaKind) {
                          MediaKind.radio => _RadioPlayerPage(
                              animationDuration: animationDuration,
                              audioHandler: audioHandler,
                              playerKind: playerKind,
                            ),
                          MediaKind.recording =>
                            _RecordingPlayerPage(audioHandler: audioHandler)
                        },
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
    });
  }
}

class _RecordingPlayerPage extends StatelessWidget {
  const _RecordingPlayerPage({
    required this.audioHandler,
  });

  final RaPlayerHandler audioHandler;

  List<Widget> _build(BuildContext context, MediaItem? mediaItem) => [
        const SizedBox(height: 16),
        RaImage(
          imageUrl: mediaItem?.artUri?.toString() ?? 'assets/defaultMedia.png',
        ),
        _StreamTitle(
          audioHandler: audioHandler,
          width: MediaQuery.sizeOf(context).width,
          textStyle: context.textStyles.textMediumLight,
          intervalSpaces: 10,
        ),
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: audioHandler.progress,
              builder: (context, progress, child) {
                return Text(
                  progress.current.formattedMinsAndSecs(),
                  style: context.textStyles.textSmallWhite,
                );
              },
            ),
            _RecordingSeekBar(
              audioHandler: audioHandler,
              width: MediaQuery.sizeOf(context).width / 1.8,
            ),
            Text(
              mediaItem?.duration?.formattedMinsAndSecs() ?? '00:00',
              style: context.textStyles.textSmallWhite
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: audioHandler.rewind,
              child: Icon(
                Icons.fast_rewind,
                color: context.colors.highlightGreen,
                size: 40,
              ),
            ),
            _PlayButton(
              audioHandler: audioHandler,
              size: 50,
            ),
            GestureDetector(
              onTap: audioHandler.fastForward,
              child: Icon(
                Icons.fast_forward,
                color: context.colors.highlightGreen,
                size: 40,
              ),
            ),
          ],
        ),
        CustomPaddingHtmlWidget(
          htmlContent: mediaItem?.extras?['description'] as String? ?? '',
          style: context.textStyles.textSmallWhite,
          padding: const EdgeInsets.only(
              bottom: RaPageConstraints.radioPlayerHeight),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.mediaItem.stream,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        final widgets = _build(context, mediaItem);
        return ListView.separated(
          itemBuilder: (context, index) => widgets[index],
          separatorBuilder: (context, _) => const SizedBox(height: 12),
          itemCount: widgets.length,
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
            child: _PlayButton(
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
              style: context.textStyles.textMediumLightNormal,
            ),
            _StreamTitle(
              audioHandler: audioHandler,
              width: MediaQuery.sizeOf(context).width,
              textStyle: context.textStyles.textMediumLight,
              intervalSpaces: 10,
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          '${context.l10n.ramowka}:',
          style: context.textStyles.textMediumLightNormal,
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
                style: context.textStyles.textMediumGreen,
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
                    PlayerKind.widget => _PlayButton(
                        audioHandler: audioHandler,
                        size: RaPlayerWidget._playerButtonSize,
                      ),
                    PlayerKind.page => const SizedBox(width: 12),
                  },
                  _StreamTitle(
                    audioHandler: audioHandler,
                    width: MediaQuery.sizeOf(context).width / 1.65,
                    overrideTitle: switch (playerKind) {
                      PlayerKind.widget => null,
                      PlayerKind.page =>
                        audioHandler.mediaKind.value.toL10nString(context),
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
          color: context.colors.backgroundDark,
          width: MediaQuery.sizeOf(context).width,
          padding: RaPageConstraints.outerWidgetPagePadding,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: switch (mediaKind) {
              MediaKind.radio => 0.0,
              MediaKind.recording => switch (playerKind) {
                  PlayerKind.widget => 1.0,
                  PlayerKind.page => 0
                },
            },
            child: _RecordingSeekBar(
              audioHandler: audioHandler,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordingSeekBar extends HookWidget {
  const _RecordingSeekBar({
    required this.audioHandler,
    this.width,
  });

  final RaPlayerHandler audioHandler;
  final double? width;

  double _calculateSeekBarWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const pagePadding = RaPageConstraints.pagePaddingValue;
    return screenWidth - 2 * pagePadding;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? _calculateSeekBarWidth(context),
      child: Center(
        child: ValueListenableBuilder<ProgressBarState>(
          valueListenable: audioHandler.progress,
          builder: (context, progress, _) {
            return ProgressBar(
              progress: progress.current,
              total: progress.total,
              buffered: progress.buffered,
              thumbColor: context.colors.highlightRed,
              thumbRadius: RaPlayerWidget._seekBarThumbRadius,
              thumbGlowRadius: RaPlayerWidget._seekBarThumbGlowRadius,
              bufferedBarColor: context.colors.backgroundLightSecondary,
              baseBarColor: context.colors.backgroundLight,
              progressBarColor: context.colors.highlightGreen,
              thumbCanPaintOutsideBar: false,
              timeLabelLocation: TimeLabelLocation.none,
              onSeek: audioHandler.seek,
            );
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

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.audioHandler,
    required this.size,
  });

  final RaPlayerHandler audioHandler;
  final double size;

  static const padding = EdgeInsets.symmetric(
    horizontal: RaPageConstraints.pagePaddingValue,
  );

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
class _StreamTitle extends StatelessWidget {
  const _StreamTitle({
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

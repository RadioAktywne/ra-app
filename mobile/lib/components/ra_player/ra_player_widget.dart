import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_dropdown_icon.dart';
import 'package:radioaktywne/components/ra_image.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/components/ramowka/ramowka_widget.dart';
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
        builder: (context, playerKind, child) {
          return ValueListenableBuilder(
              valueListenable: audioHandler.mediaKind,
              builder: (context, mediaKind, child) {
                return GestureDetector(
                  // TODO: this interferes with the click on the keyboard_arrow_down
                  // onVerticalDragDown: (details) {
                  //   if (playerKind == PlayerKind.page) {
                  //     audioHandler.changePlayerKind();
                  //   }
                  // },
                  child: AnimatedContainer(
                    duration: animationDuration,
                    color: switch (playerKind) {
                      PlayerKind.widget =>
                        context.colors.backgroundDarkSecondary,
                      PlayerKind.page => context.colors.backgroundDark,
                    },
                    margin: switch (playerKind) {
                      PlayerKind.page => EdgeInsets.zero,
                      PlayerKind.widget =>
                        RaPageConstraints.outerWidgetPagePadding,
                    },
                    height: switch (playerKind) {
                      PlayerKind.widget => RaPageConstraints.radioPlayerHeight,
                      PlayerKind.page => MediaQuery.of(context).size.height,
                    },
                    child: Wrap(
                      spacing: 15,
                      // direction: Axis.horizontal,
                      // alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        AnimatedPadding(
                          duration: animationDuration,
                          padding: switch (playerKind) {
                                PlayerKind.page =>
                                  RaPageConstraints.outerWidgetPagePadding,
                                PlayerKind.widget => EdgeInsets.zero,
                              } +
                              const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (playerKind == PlayerKind.widget)
                                    PlayerPlayButton(
                                      audioHandler: audioHandler,
                                      size: _playerSize,
                                    ),
                                  _PlayerTitle(
                                    audioHandler: audioHandler,
                                    width: MediaQuery.of(context).size.width /
                                        1.65,
                                    overrideTitle: switch (playerKind) {
                                      PlayerKind.widget => null,
                                      PlayerKind.page =>
                                        context.mediaKindToString(
                                            audioHandler.mediaKind.value),
                                    },
                                  ),
                                ],
                              ),
                              RaSplash(
                                onPressed: audioHandler.changePlayerKind,
                                child:
                                    RaDropdownIcon(audioHandler: audioHandler),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height - 200,
                          child: AnimatedOpacity(
                            duration: animationDuration,
                            opacity: switch (playerKind) {
                              PlayerKind.widget => 0.0,
                              PlayerKind.page => 1.0
                            },
                            child: Padding(
                              padding:
                                  RaPageConstraints.outerWidgetPagePadding * 2,
                              child: ListView(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: AspectRatio(
                                      aspectRatio: 1.4 / 1,
                                      child: PlayerPlayButton(
                                        audioHandler: audioHandler,
                                        size: 120,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${context.l10n.nowPlaying}:',
                                        style: context.textStyles.textMedium
                                            .copyWith(
                                          color: context.colors.backgroundLight,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      _PlayerTitle(
                                        audioHandler: audioHandler,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        textStyle: context.textStyles.textMedium
                                            .copyWith(
                                          color: context.colors.backgroundLight,
                                        ),
                                        intervalSpaces: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 70),
                                  Text(
                                    '${context.l10n.ramowka}:',
                                    style:
                                        context.textStyles.textMedium.copyWith(
                                      color: context.colors.backgroundLight,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const RamowkaList(rows: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        RaSplash(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'wróć na stronę główną', // '⮌' symbol not working
                                    style:
                                        context.textStyles.textMedium.copyWith(
                                      color: context.colors.highlightGreen,
                                    ),
                                  ),
                                  Padding(
                                    padding: RaPageConstraints
                                        .outerWidgetPagePadding,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.keyboard_return_outlined,
                                        color: context.colors.highlightGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ListView(
                    //   // TODO: just do this with listview :D
                    //   // TODO: make it not scrollable though! (at least in hidden mode)
                    //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //
                    //
                  ),
                );
              });
        });
    // Stack(
    //   children: [
    //     Positioned(
    //       bottom: 0,
    //       child: _SeekBar(
    //         audioHandler: audioHandler,
    //       ),
    //     ),
    //     AnimatedPositioned(
    //       duration: animationDuration,
    //       bottom: switch (mediaKind) {
    //         MediaKind.radio => 0,
    //         MediaKind.recording => RaPageConstraints.radioPlayerHeight * 2,
    //       },
    //       left: 12,
    //       child: _BackButton(
    //         audioHandler: audioHandler,
    //       ),
    //     ),
    //     AnimatedPositioned(
    //       duration: animationDuration,
    //       bottom: switch (mediaKind) {
    //         MediaKind.radio => 0,
    //         MediaKind.recording => RaPageConstraints.radioPlayerHeight,
    //       },
    //       child: _Player(audioHandler: audioHandler),
    //     ),
    //   ],
    // );
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

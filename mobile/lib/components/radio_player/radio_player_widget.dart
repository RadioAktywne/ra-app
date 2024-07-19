import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
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
class RadioPlayerWidget extends HookWidget {
  const RadioPlayerWidget({super.key});

  /// Measurements from Figma
  static const double buttonSize = 37;
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 14);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
      builder: (context, audioHandler) {
        return Container(
          height: RaPageConstraints.radioPlayerHeight,
          color: context.colors.backgroundDarkSecondary,
          child: Row(
            children: switch (audioHandler) {
              null => [
                  Padding(
                    padding: horizontalPadding,
                    child: RaPlayButton(
                      onPressed: () {},
                      size: buttonSize,
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
                  StreamPlayButton(
                    audioHandler: audioHandler,
                  ),
                  StreamTitle(
                    audioHandler: audioHandler,
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
      },
    );
  }

  /// Logic for the seek bar. It could be helpful when playing recordings.
  /// A stream reporting the combined state of the current media item and its
  /// current position.
// Stream<MediaState> get _mediaStateStream =>
//     Rx.combineLatest2<MediaItem?, Duration, MediaState>(
//       audioHandler.mediaItem,
//       AudioService.position,
//       MediaState.new,
//     );

  /// Very basic button used in development, provided in library example of use.
  /// Leaving it for potential use in future development.
  // IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
  //       icon: Icon(iconData),
  //       iconSize: 64,
  //       onPressed: onPressed,
  //     );
}

/// Logic for the seek bar - continued
// class MediaState {
//   MediaState(this.mediaItem, this.position);

//   final MediaItem? mediaItem;
//   final Duration position;
// }

/// The [RaPlayButton] controlling the radio stream.
class StreamPlayButton extends StatelessWidget {
  const StreamPlayButton({
    super.key,
    required this.audioHandler,
    this.buttonSize,
    this.padding,
  });

  final AudioHandler audioHandler;
  final double? buttonSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? RadioPlayerWidget.horizontalPadding,
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
                size: buttonSize ?? RadioPlayerWidget.buttonSize,
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
class StreamTitle extends StatelessWidget {
  const StreamTitle({
    super.key,
    required this.audioHandler,
    this.width,
    this.style,
  });

  final AudioHandler audioHandler;
  final double? width;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return SizedBox(
          width: width ?? MediaQuery.of(context).size.width / 1.4,
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
            style: style ?? context.textStyles.textPlayer,
          ),
        );
      },
    );
  }
}

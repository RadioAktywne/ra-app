import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

/// The radio player, consisting of a [RaPlayButton]
/// and stream title.
///
/// Should be positioned at the bottom of the screen,
/// "attached" to the navigation bar
/// (in accordance to Figma).
class RadioPlayerWidget extends HookWidget {
  const RadioPlayerWidget({super.key});

  /// Measurements from Figma
  static const double buttonSize = 37;
  static const double height = 50;
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
      builder: (context, audioHandler) {
        return Container(
          height: height,
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
                    'No stream title', // TODO: Wymienić na 'Radio Aktywne'
                    style: context.textStyles.textPlayer,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              _ => [
                  _StreamPlayButton(
                    audioHandler: audioHandler,
                  ),
                  _StreamTitle(
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
        return (mediaItem?.title != null && mediaItem!.title.isNotEmpty == true)
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                height: RadioPlayerWidget.height,
                // TODO: Zmienić na Marquee zamiast Text
                child: Text(
                  mediaItem.title,
                  style: context.textStyles.textPlayer,
                ),
              )
            : Text(
                'No stream title', // TODO: Wymienić na 'Radio Aktywne'
                style: context.textStyles.textPlayer,
                overflow: TextOverflow.ellipsis,
              );
      },
    );
  }
}

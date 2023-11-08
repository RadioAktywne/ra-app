import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:marquee/marquee.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

class RadioAudioService extends HookWidget {
  const RadioAudioService({super.key});

  static const double _buttonSize = 37;
  static const double _height = 50;
  static const EdgeInsets _horizontalPadding =
      EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
      builder: (context, audioHandler) {
        return Container(
          height: _height,
          color: context.colors.backgroundDarkSecondary,
          child: Row(
            children: [
              if (audioHandler == null)
                Padding(
                  padding: _horizontalPadding,
                  child: RaPlayButton(
                    onPressed: () {},
                    size: _buttonSize,
                    audioProcessingState: AudioProcessingState.loading,
                  ),
                )
              else
                Row(
                  children: [
                    Padding(
                      padding: _horizontalPadding,
                      child: StreamBuilder<AudioProcessingState>(
                        stream: audioHandler.playbackState
                            .map((state) => state.processingState)
                            .distinct(),
                        builder: (context, snapshot) {
                          final processingState =
                              snapshot.data ?? AudioProcessingState.idle;
                          return StreamBuilder<bool>(
                            stream: audioHandler.playbackState
                                .map((state) => state.playing)
                                .distinct(),
                            builder: (context, snapshot) {
                              final playing = snapshot.data ?? false;
                              return RaPlayButton(
                                size: _buttonSize,
                                onPressed: playing
                                    ? audioHandler.stop
                                    : audioHandler.play,
                                audioProcessingState: processingState,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: _horizontalPadding,
                      child: StreamBuilder<MediaItem?>(
                        stream: audioHandler.mediaItem,
                        builder: (context, snapshot) {
                          final mediaItem = snapshot.data;
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Column(
                              children: [
                                if (mediaItem?.title != null &&
                                    mediaItem!.title.isNotEmpty == true)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height: _height,
                                    child: Marquee(
                                      text: mediaItem.title,
                                      blankSpace: 20,
                                      velocity: 13,
                                      startAfter: const Duration(seconds: 3),
                                      startPadding: 40,
                                      style: context.textStyles.textPlayer,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                else
                                  Text(
                                    'No stream title', // TODO: Wymienić na 'Radio Aktywne'
                                    style: context.textStyles.textPlayer,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                // if (mediaItem?.album != null &&
                                //     mediaItem!.album!.isNotEmpty == true)
                                //   Text(mediaItem.album!)
                                // else
                                //   const Text(
                                //     'No radio station name',
                                //     style: TextStyle(
                                //         fontStyle: FontStyle.italic),
                                //   ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );

        if (audioHandler == null) {
          return const Column(
            children: [
              CircularProgressIndicator(),
              Text('Player is loading...'),
            ],
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show media item title

            // Play/pause/stop buttons.
            StreamBuilder<bool>(
              stream: audioHandler.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return RaPlayButton(
                  size: 64,
                  onPressed: playing ? audioHandler.stop : audioHandler.play,
                );
              },
            ),

            /// A seek bar. It could be helpful when playing recordings.
            // StreamBuilder<MediaState>(
            //   stream: _mediaStateStream,
            //   builder: (context, snapshot) {
            //     final mediaState = snapshot.data;
            //     return SeekBar(
            //       duration: mediaState?.mediaItem?.duration ?? Duration.zero,
            //       position: mediaState?.position ?? Duration.zero,
            //       onChangeEnd: (newPosition) {
            //         audioHandler.seek(newPosition);
            //       },
            //       bufferedPosition: Duration.zero,
            //     );
            //   },
            // ),
            /// Display the stream processing state. Leaving this for help
            /// with future development.
            StreamBuilder<AudioProcessingState>(
              stream: audioHandler.playbackState
                  .map((state) => state.processingState)
                  .distinct(),
              builder: (context, snapshot) {
                final processingState =
                    snapshot.data ?? AudioProcessingState.idle;
                return Text(
                  'Processing state: ${describeEnum(processingState)}',
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Logic for the seek bar. It could be helpful when playing recordings.
// /// A stream reporting the combined state of the current media item and its
// /// current position.
// Stream<MediaState> get _mediaStateStream =>
//     Rx.combineLatest2<MediaItem?, Duration, MediaState>(
//       audioHandler.mediaItem,
//       AudioService.position,
//       MediaState.new,
//     );
//
// class MediaState {
//   MediaState(this.mediaItem, this.position);
//
//   final MediaItem? mediaItem;
//   final Duration position;
// }

  /// Very basic button used in development, provided in library example of use.
  /// Leaving it for potential use in future development.
// IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
//       icon: Icon(iconData),
//       iconSize: 64,
//       onPressed: onPressed,
//     );
}

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioaktywne/components/ra_playbutton.dart';
import 'package:radioaktywne/state/audio_handler_cubit.dart';

class RadioAudioService extends StatelessWidget {
  const RadioAudioService({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioHandlerCubit, AudioHandler?>(
      builder: (context, audioHandler) {
        if (audioHandler == null) {
          return const Column(
            children: [
              CircularProgressIndicator(),
              Text('Player is loading...'),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show media item title
              StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  return Column(
                    children: [
                      if (mediaItem?.title != null &&
                          mediaItem!.title.isNotEmpty == true)
                        Text(mediaItem.title)
                      else
                        const Text(
                          'No stream title',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      if (mediaItem?.album != null &&
                          mediaItem!.album!.isNotEmpty == true)
                        Text(mediaItem.album!)
                      else
                        const Text(
                          'No radio station name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  );
                },
              ),
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
        }
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

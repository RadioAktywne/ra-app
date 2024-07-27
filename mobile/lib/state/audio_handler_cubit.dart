import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radioaktywne/components/radio_player/audio_player_handler.dart';

class AudioHandlerCubit extends Cubit<AudioPlayerHandler> {
  /*
  initializing AudioHandlerCubit with null because proper init is asynchronous,
  but cubit init has to be synchronous, so it needs something to store
   */
  AudioHandlerCubit({required MediaItem initialMedia})
      : super(
          AudioPlayerHandler(mediaItem: AudioPlayerConstants.radioMediaItem),
        ) {
    initAudioHandler(initialMedia);
  }

  Future<void> initAudioHandler(MediaItem initialMedia) async {
    final audioService = await AudioService.init(
      builder: () => AudioPlayerHandler(mediaItem: initialMedia),
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Live radio stream',
        androidNotificationOngoing: true,
      ),
    );
    // setting proper AudioService object as state, notifying listeners
    emit(audioService);
  }
}

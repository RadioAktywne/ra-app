import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radioaktywne/components/radio_player/audio_player_handler.dart';

class AudioHandlerCubit extends Cubit<AudioHandler?> {
  /*
  initializing AudioHandlerCubit with null because proper init is asynchronous,
  but cubit init has to be synchronous, so it needs something to store
   */
  AudioHandlerCubit({required MediaItem initialMedia}) : super(null) {
    if (kDebugMode) {
      print('Initialized AudioHandlerCubit');
    }
    initAudioHandler(initialMedia); // proper 'init function' call
  }

  Future<void> initAudioHandler(MediaItem initialMedia) async {
    final audioService = await AudioService.init(
      builder: () => AudioPlayerHandler(mediaSource: initialMedia),
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Live radio stream',
        androidNotificationOngoing: true,
      ),
    );
    // setting proper AudioService object as state, notifying listeners
    emit(audioService);
  }
}

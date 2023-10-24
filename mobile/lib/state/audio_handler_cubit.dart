import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/radio_player/audio_player_handler.dart';

class AudioHandlerCubit extends Cubit<AudioHandler?> {
  /*
  initializing AudioHandlerCubit with null because proper init is asynchronous,
  but cubit init has to be synchronous, so it needs something to store
   */
  AudioHandlerCubit() : super(null) {
    initAudioHandler(); // proper 'init function' call
  }

  Future<void> initAudioHandler() async {
    final audioService = await AudioService.init(
      builder: AudioPlayerHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Live radio stream',
        androidNotificationOngoing: true,
      ),
    );
    // setting proper AudioService object as state, notifying listeners
    emit(audioService);
  }

}

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radioaktywne/components/ra_player/ra_player_handler.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';

class AudioHandlerCubit extends Cubit<RaPlayerHandler> {
  /*
  initializing AudioHandlerCubit with null because proper init is asynchronous,
  but cubit init has to be synchronous, so it needs something to store
   */
  AudioHandlerCubit({required MediaItem initialMedia}) : super(handler) {
    initAudioHandler(initialMedia);
  }

  static final RaPlayerHandler handler =
      RaPlayerHandler(mediaItem: radioMediaItem);

  Future<void> initAudioHandler(MediaItem initialMedia) async {
    final audioService = await AudioService.init(
      builder: () => handler,
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Live radio stream',
        androidNotificationOngoing: true,
        // androidNotificationIcon: ..., // TODO: add custom icon
      ),
    );
    // setting proper AudioService object as state, notifying listeners
    emit(audioService);
  }
}

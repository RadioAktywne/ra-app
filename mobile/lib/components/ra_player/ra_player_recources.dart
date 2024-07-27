import 'package:audio_service/audio_service.dart';

abstract class RaPlayerConstants {
  static const String mediaKind = 'mediaKind';
  static const String seek = 'seek';

  static final radioMediaItem = MediaItem(
    id: 'https://listen.radioaktywne.pl:8443/raogg',
    title: 'Stream title not provided', // TODO: zmienić na 'Radio Aktywne'
    album: 'Stream name not provided', // TODO: zmienić na 'Radio Aktywne'
    artUri: Uri.parse(
      'https://cdn-profiles.tunein.com/s10187/images/logod.png',
    ),
    extras: {
      mediaKind: MediaKind.radio,
    },
  );
}

enum MediaKind {
  radio,
  recording;
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

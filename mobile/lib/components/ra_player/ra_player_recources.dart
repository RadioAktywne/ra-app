import 'package:audio_service/audio_service.dart';
import 'package:radioaktywne/resources/ra_links.dart';

abstract class RaPlayerConstants {
  const RaPlayerConstants._();

  static const String mediaKind = 'mediaKind';
  static const String seek = 'seek';

  static final radioMediaItem = MediaItem(
    id: Uri.https(RaLinks.radioPlayerBase, RaLinks.radioPlayer.radioStream)
        .toString(),
    title: 'Radio Aktywne',
    album: 'Radio Aktywne',
    artUri: Uri.parse(RaLinks.logo),
    extras: {
      RaPlayerConstants.mediaKind: MediaKind.radio,
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

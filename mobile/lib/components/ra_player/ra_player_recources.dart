import 'package:audio_service/audio_service.dart';
import 'package:radioaktywne/resources/ra_links.dart';

abstract class RaPlayerConstants {
  static final radioMediaItem = MediaItem(
    id: Uri.https(RaRadio.baseUrl, RaRadio.radioStream).toString(),
    title: 'Radio Aktywne',
    album: 'Radio Aktywne',
    artUri: Uri.parse(RaApi.logoUrl),
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

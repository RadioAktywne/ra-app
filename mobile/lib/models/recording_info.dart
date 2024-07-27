import 'package:audio_service/audio_service.dart';
import 'package:radioaktywne/components/ra_player/ra_player_recources.dart';

class RecordingInfo {
  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : title = (jsonData['acf'] as Map<String, dynamic>)['title'] as String,
        thumbnailPath =
            ((jsonData['acf'] as Map<String, dynamic>)['image'] as int)
                .toString(),
        recordingPath =
            ((jsonData['acf'] as Map<String, dynamic>)['file'] as int)
                .toString(),
        duration = Duration.zero,
        seek = Duration.zero;

  final String title;
  String thumbnailPath;
  String recordingPath;
  Duration duration;
  Duration seek;

  MediaItem get mediaItem => MediaItem(
        id: recordingPath,
        title: title,
        duration: duration,
        extras: {
          RaPlayerConstants.mediaKind: MediaKind.recording,
          RaPlayerConstants.seek: seek,
        },
      );

  @override
  String toString() {
    return '''
RecordingInfo {
  title=$title,
  thumbnailPath=$thumbnailPath,
  recordingPath=$recordingPath,
  duration=$duration,
  seek=$seek,
}''';
  }
}

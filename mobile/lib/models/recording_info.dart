import 'package:audio_service/audio_service.dart';

class RecordingInfo {
  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData['acf']['title'] as String,
        thumbnailPath = jsonData['acf']['image'].toString(),
        recordingPath = jsonData['acf']['file'].toString(),
        duration = Duration.zero;

  final String title;
  String thumbnailPath;
  String recordingPath;
  Duration duration;

  MediaItem get mediaItem => MediaItem(
        id: recordingPath,
        title: title,
        artist: 'Radio Aktywne', // TODO: use l10n
        duration: duration,
        artUri: Uri.parse(thumbnailPath),
      );

  @override
  String toString() {
    return '''
RecordingInfo {
  title=$title,
  thumbnailPath=$thumbnailPath,
  recordingPath=$recordingPath,
  duration=$duration,
}''';
  }
}

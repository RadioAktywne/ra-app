import 'package:audio_service/audio_service.dart';

class RecordingInfo {
  RecordingInfo({
    required this.id,
    required this.title,
    required this.thumbnailPath,
    required this.recordingPath,
    required this.duration,
  });

  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] as int,
        title = jsonData['acf']['title'] as String,
        thumbnailPath = jsonData['acf']['image'].toString(),
        recordingPath = jsonData['acf']['file'].toString(),
        duration = Duration.zero;

  final int id;
  final String title;
  String thumbnailPath;
  String recordingPath;
  Duration duration;

  MediaItem get mediaItem => MediaItem(
        id: recordingPath,
        title: title,
        artist: 'Radio Aktywne',
        duration: duration,
        artUri: Uri.parse(thumbnailPath),
      );

  @override
  String toString() {
    return '''
RecordingInfo {
  id=$id,
  title=$title,
  thumbnailPath=$thumbnailPath,
  recordingPath=$recordingPath,
  duration=$duration,
}''';
  }
}

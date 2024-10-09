import 'package:audio_service/audio_service.dart';

class RecordingInfo {
  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] as int,
        title = jsonData['acf']['title'] as String,
        thumbnailPath = jsonData['acf']['image'].toString(),
        recordingPath = jsonData['acf']['file'].toString(),
        description = jsonData['acf']['description'].toString(),
        duration = Duration.zero;
        

  final int id;
  final String title;
  String thumbnailPath;
  String recordingPath;
  String description;
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
  id=$id,
  title=$title,
  thumbnailPath=$thumbnailPath,
  recordingPath=$recordingPath,
  description=$description,
  duration=$duration,
}''';
  }
}

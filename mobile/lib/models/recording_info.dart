import 'package:audio_service/audio_service.dart';

class RecordingInfo {
  RecordingInfo({
    required this.id,
    required this.title,
    required this.thumbnailPath,
    required this.recordingPath,
    required this.duration,
    required this.description,
  });

  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] as int,
        title = jsonData['acf']['title'] as String,
        thumbnailPath = jsonData['acf']['image'].toString(),
        fullImagePath = jsonData['acf']['image'].toString(),
        recordingPath = jsonData['acf']['file'].toString(),
        duration = Duration.zero,
        description = jsonData['acf']['description'] as String;

  final int id;
  final String title;
  String thumbnailPath;
  String fullImagePath;
  String recordingPath;
  String description;
  Duration duration;

  MediaItem get mediaItem => MediaItem(
        id: recordingPath,
        title: title,
        artist: 'Radio Aktywne', // TODO: use l10n
        duration: duration,
        artUri: Uri.parse(thumbnailPath),
        extras: {'description': description},
      );

  @override
  String toString() {
    return '''
RecordingInfo {
  id=$id,
  title=$title,
  thumbnailPath=$thumbnailPath,
  fullImagePath=$fullImagePath,
  recordingPath=$recordingPath,
  description=$description,
  duration=$duration,
  description=$description,
}''';
  }
}

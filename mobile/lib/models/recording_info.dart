class RecordingInfo {
  RecordingInfo.fromJson(Map<String, dynamic> jsonData)
      : title =
            (jsonData['title'] as Map<String, dynamic>)['rendered'] as String,
        thumbnailPath =
            ((jsonData['acf'] as Map<String, dynamic>)['image'] as int)
                .toString(),
        recordingPath =
            ((jsonData['acf'] as Map<String, dynamic>)['file'] as int)
                .toString();

  final String title;
  String thumbnailPath;
  String recordingPath;
}

// ignore_for_file: avoid_dynamic_calls

class RecordingsInfo {
  /// Creates an empty [RecordingsInfo] object.
  RecordingsInfo.empty()
      : id = -1,
        title = '',
        description = '',
        thumbnail = '';

  /// Creates a [RecordingsInfo] object from a given Json map.
  RecordingsInfo.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] as int,
        title = jsonData['acf']['title'] as String,
        description = jsonData['acf']['description'] as String,
        thumbnail = jsonData['_links']['wp:attachment'][0]
            ['href'] as String;

  final int id;
  final String title;
  final String description;
  final String thumbnail;

  bool get isNotEmpty =>
      title.isNotEmpty && description.isNotEmpty;

  @override
  String toString() {
    return '''
    ArticleInfo {
      title: `$title`, 
      description: `$description`,
      thumbnail: `$thumbnail`,
    }
    ''';
  }
}

class ArticleSelectionInfo {

  ArticleSelectionInfo.empty() : thumbnail = '';

  ArticleSelectionInfo.fromJson(Map<String, dynamic> jsonData) :
      thumbnail = (jsonData['guid']as Map<String, dynamic>)['rendered'] as String;
      // thumbnail = jsonData['date'] as String;

  final String thumbnail;

  bool get isNotEmpty => thumbnail.isNotEmpty;

  @override
  String toString() {
    return '''
    ArticleSelectionInfo {
      thumbnail: '$thumbnail',
    }
    ''';
  }
}

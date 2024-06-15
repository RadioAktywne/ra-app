/// Information about a single article.
class ArticleInfo {
  /// Creates an empty [ArticleInfo] object.
  ArticleInfo.empty()
      : title = '',
        content = '',
        imageTag = '';

  /// Creates a [ArticleInfo] object from a given Json map.
  ArticleInfo.fromJson(Map<String, dynamic> jsonData)
      : title = _parseTitle(
          (jsonData['title'] as Map<String, dynamic>)['rendered'] as String,
        ),
        content =
            (jsonData['content'] as Map<String, dynamic>)['rendered'] as String,
        imageTag = jsonData['featured_media'].toString();

  final String title;
  final String content;
  String imageTag;

  bool get isNotEmpty =>
      title.isNotEmpty && content.isNotEmpty && imageTag.isNotEmpty;

  static String _parseTitle(String title) {
    return title.replaceAll('&#8211;', '–');
  }

  @override
  String toString() {
    return '''
    ArticleInfo {
      title: `$title`, 
      content: `$content`,
      imageTag: `$imageTag`,
    }
    ''';
  }
}

/// Information about a single article.
class ArticleInfo {
  /// Creates an empty [ArticleInfo] object.
  ArticleInfo.empty()
      : id = 0,
        date = '',
        title = '',
        content = '',
        authorName = '',
        featuredMediaUrl = '';

  /// Creates a [ArticleInfo] object from a given Json map.
  ArticleInfo.fromJson(Map<String, dynamic> jsonData)
        : id = jsonData['id'] as int,
          date = jsonData['date'] as String,
          title = (jsonData['title'] as Map<String, dynamic>)['rendered'] as String,
          content = (jsonData['content'] as Map<String, dynamic>)['rendered'] as String,
          authorName = _parseAuthorName(jsonData['_embedded'] as Map<String, dynamic>?),
          featuredMediaUrl = _parseFeaturedMediaUrl(jsonData['_embedded'] as Map<String, dynamic>?);

  final int id;
  final String date;
  final String title;
  final String content;
  final String authorName;
  final String featuredMediaUrl;

  bool get isNotEmpty =>
      id != 0 && title.isNotEmpty && content.isNotEmpty;

  @override
  String toString() {
    return '''
    ArticleInfo {
      id: `$id`,
      date: `$date`,
      title: `$title`, 
      content: `$content`,
      authorName: `$authorName`,
      featuredMediaUrl: `$featuredMediaUrl`,
    }
    ''';
  }

  static String _parseAuthorName(Map<String, dynamic>? embedded) {
    if (embedded != null && embedded['author'] != null) {
      final authors = embedded['author'] as List<dynamic>;
      if (authors.isNotEmpty) {
        final author = authors[0] as Map<String, dynamic>;
        return author['name'] as String;
      }
    }
    return '';
  }

  static String _parseFeaturedMediaUrl(Map<String, dynamic>? embedded) {
    if (embedded != null && embedded['wp:featuredmedia'] != null) {
      final mediaList = embedded['wp:featuredmedia'] as List<dynamic>;
      if (mediaList.isNotEmpty) {
        final media = mediaList[0] as Map<String, dynamic>;
        return media['source_url'] as String;
      }
    }
    return '';
  }
}

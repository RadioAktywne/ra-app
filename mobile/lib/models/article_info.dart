/// Information about a single article.
class ArticleInfo {
  /// Creates an empty [ArticleInfo] object.
  ArticleInfo.empty()
      : id = -1,
        title = '',
        content = '',
        thumbnail = '',
        mediumLarge = '',
        fullImage = '';

  /// Creates a [ArticleInfo] object from a given Json map.
  ArticleInfo.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] as int,
        title = jsonData['title']['rendered'] as String,
        content = jsonData['content']['rendered'] as String,
        thumbnail = jsonData['_embedded']['wp:featuredmedia'][0]
            ['media_details']['sizes']['thumbnail']?['source_url'] as String?,
        mediumLarge = jsonData['_embedded']['wp:featuredmedia'][0]
                ['media_details']['sizes']['medium_large']?['source_url']
            as String?,
        fullImage = jsonData['_embedded']['wp:featuredmedia'][0]
            ['media_details']['sizes']['full']['source_url'] as String;

  final int id;
  final String title;
  final String content;
  final String? thumbnail;
  final String? mediumLarge;
  final String fullImage;

  bool get isNotEmpty => title.isNotEmpty && content.isNotEmpty;

  @override
  String toString() {
    return '''
    ArticleInfo {
      title: `$title`, 
      content: `$content`,
      thumbnail: `$thumbnail`,
      ${mediumLarge != null ? 'mediumLarge: `$mediumLarge`, ' : ''}
      fullImage: `$fullImage`,
    }
    ''';
  }
}

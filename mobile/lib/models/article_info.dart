/// Information about a single article.
class ArticleInfo {
  /// Creates an empty [ArticleInfo] object.
  ArticleInfo.empty()
      : title = '',
        content = '',
        thumbnail = '',
        fullImage = '',
        imageTag = '';

  /// Creates a [ArticleInfo] object from a given Json map.
  ArticleInfo.fromJson(Map<String, dynamic> jsonData)
      : title = (jsonData['title'] as Map<String, dynamic>)['rendered'] as String,
        content =
            (jsonData['content'] as Map<String, dynamic>)['rendered'] as String,
        thumbnail = jsonData['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['thumbnail']['source_url'] as String,
        fullImage = jsonData['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['full']['source_url'] as String,
        imageTag = jsonData['featured_media'].toString();

  final String title;
  final String content;
  final String thumbnail;
  final String fullImage;
  String imageTag;

  bool get isNotEmpty =>
      title.isNotEmpty && content.isNotEmpty && imageTag.isNotEmpty;
      

  @override
  String toString() {
    return '''
    ArticleInfo {
      title: `$title`, 
      content: `$content`,
      thumbnail: `$thumbnail`,
      fullImage: `$fullImage`,
      imageTag: `$imageTag`,
    }
    ''';
  }
}

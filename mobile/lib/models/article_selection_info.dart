class ArticleSelectionInfo {

  ArticleSelectionInfo.empty() : thumbnail = '', title = '', link = '';

ArticleSelectionInfo.fromJson(Map<String, dynamic> jsonData) :
      thumbnail = jsonData['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['thumbnail']['source_url'] as String,
      title = (jsonData['title'] as Map<String, dynamic>)['rendered'] as String,
      link = jsonData['_links']['self'][0]['href'] as String;


      // thumbnail = jsonData['date'] as String;

  final String thumbnail;
  final String title;
  final String link;

  bool get isNotEmpty => thumbnail.isNotEmpty && title.isNotEmpty;

  @override
  String toString() {
    return '''
    ArticleSelectionInfo {
      thumbnail: '$thumbnail',
      title: '$title',
      link: '$link',
    }
    ''';
  }
}

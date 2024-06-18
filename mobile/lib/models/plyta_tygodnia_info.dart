/// Information about a single Plyta tygodnia.
class PlytaTygodniaInfo {
  /// Creates an empty [PlytaTygodniaInfo] object.
  PlytaTygodniaInfo.empty()
      : artist = '',
        title = '',
        description = '',
        imageTag = '';

  /// Creates a [PlytaTygodniaInfo] object from a given Json map.
  PlytaTygodniaInfo.fromJson(Map<String, dynamic> jsonData)
      : artist = (jsonData['acf'] as Map<String, dynamic>)['artist'] as String,
        title = (jsonData['acf'] as Map<String, dynamic>)['title'] as String,
        description =
            (jsonData['acf'] as Map<String, dynamic>)['description'] as String,
        imageTag = ((jsonData['acf'] as Map<String, dynamic>)['image'] as int)
            .toString();

  final String artist;
  final String title;
  final String description;
  String imageTag;

  bool get isNotEmpty =>
      artist != '' || title != '' || description != '' || imageTag != '';

  @override
  String toString() {
    return '''
    Plyta tygodnia {
      artist: `$artist`,
      title: `$title`, 
      description: `$description`,
    }
    ''';
  }
}

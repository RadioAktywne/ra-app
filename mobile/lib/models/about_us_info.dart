/// Information about us.
class AboutUsInfo {
  /// Creates an empty [AboutUsInfo] object.
  AboutUsInfo.empty()
      : content = '';

  /// Creates a [AboutUsInfo] object from a given Json map.
  AboutUsInfo.fromJson(Map<String, dynamic> jsonData)
      : content = jsonData['content']['rendered'] as String;

  final String content;

  bool get isNotEmpty =>
      content != '';

  @override
  String toString() {
    return '''
    O nas {
      content: `$content`,
    }
    ''';
  }
}

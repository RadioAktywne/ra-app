import 'package:flutter/foundation.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';

class NewestArticleFetch {
  Iterable<ArticleInfo> _articles = [];
  var _isLoading = false;
  var _hasError = false;

  Iterable<ArticleInfo> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> loadArticles() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    final pageUri = Uri.https(
      RaApi.baseUrl,
      RaApi.endpoints.posts,
      {
        '_embed': true,
        'page': 1,
        'per_page': 3,
      }.valuesToString(),
    );

    try {
      final newArticles = await fetchData(pageUri, ArticleInfo.fromJson);
      _articles = newArticles;
      _hasError = false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('$stackTrace: $e');
      }
      _hasError = true;
    } finally {
      _isLoading = false;
    }
  }
}

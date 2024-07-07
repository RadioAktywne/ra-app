import 'package:radioaktywne/models/article_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class NewestArticleFetch {
  Iterable<ArticleInfo> _articles = [];
  bool _isLoading = false;
  bool _hasError = false;

  Iterable<ArticleInfo> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> loadArticles() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    final pageUri = Uri.parse(
      'https://radioaktywne.pl/wp-json/wp/v2/posts?_embed=true&page=1&per_page=3',
    );

    try {
      final newArticles = await fetchData(pageUri, ArticleInfo.fromJson);
      _articles = newArticles;
      _hasError = false;
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
    }
  }
}

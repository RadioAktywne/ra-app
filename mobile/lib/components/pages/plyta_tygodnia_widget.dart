import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class PlytaTygodniaWidget extends HookWidget {
  const PlytaTygodniaWidget({
    super.key,
    this.timeout = const Duration(seconds: 7),
  });

  final Duration timeout;

  static final Uri _infoUrl = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/album?_embed=true&page=1&per_page=16',
  );
  static const _infoHeaders = {'Content-Type': 'application/json'};

  static Uri _imgUrl(String id) => Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/media?_embed=true&include[]=$id',
      );
  static const _imgHeaders = {'Content-Type': 'image/jpeg'};

  Future<PlytaTygodniaInfo> _fetchPlytaTygodnia() async {
    final data = await fetchData(
      _infoUrl,
      PlytaTygodniaInfo.fromJson,
      headers: _infoHeaders,
      timeout: timeout,
    );

    //TODO: Handle the case where no [data] comes in
    final plytaTygodnia = data.first;

    final imageUrlId = plytaTygodnia.imageTag;
    final imageUrls = await fetchData(
      _imgUrl(imageUrlId),
      (e) => (e['guid'] as Map<String, dynamic>)['rendered'] as String,
      headers: _imgHeaders,
      timeout: timeout,
    );

    //TODO: Handle the case where no [imageUrl] comes in
    final imageUrl = imageUrls.first;
    plytaTygodnia.imageTag = imageUrl;

    return plytaTygodnia;
  }

  @override
  Widget build(BuildContext context) {
    final plytaTygodniaState = useState(PlytaTygodniaInfo.empty());
    final plytaTygodniaFuture = useMemoized(_fetchPlytaTygodnia);
    final snapshot = useFuture(plytaTygodniaFuture);

    /// Called only on the first time the widget
    /// is rendered, because of the empty list argument.
    useEffect(
      () {
        plytaTygodniaFuture.then((e) => plytaTygodniaState.value = e);
        // nothing to dispose of
        return;
      },
      [],
    );

    return ListView(
      children: [
        // TODO: refactor the whole hook situation into Widget/function
        // TODO: can be called something like "RefreshablePageWidget"
        RefreshIndicator(
          color: context.colors.highlightGreen,
          backgroundColor: context.colors.backgroundDark,
          displacement: 0,
          onRefresh: () async =>
              plytaTygodniaState.value = await _fetchPlytaTygodnia(),
          child: snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : Image.network(plytaTygodniaState.value.imageTag),
        ),
      ],
    );
  }
}

/// Information about a single Plyta Tygodnia entry.
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
        imageTag = (jsonData['acf'] as Map<String, dynamic>)['image'] as String;

  final String artist;
  final String title;
  final String description;
  String imageTag;

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

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
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

  static const String _imgUrl =
      'https://radioaktywne.pl/wp-json/wp/v2/media?_embed=true&include[]=';
  static const _imgHeaders = {'Content-Type': 'image/jpeg'};

  Future<PlytaTygodniaInfo> _fetchPlytaTygodnia() async {
    final data = await fetchData(
      _infoUrl,
      PlytaTygodniaInfo.fromJson,
      headers: _infoHeaders,
      timeout: timeout,
    );

    //TODO: implement fetching image url + image
    // Pseudo-code:
    // final plytaTygodnia = data.first;
    // final imageUrlId = PlytaTygodniaInfo.imageTag;
    // final imageUrl = fetch(_imgUrl + imageUrlId);
    // final image = ;

    //TODO:
    //TODO: implement
    throw UnimplementedError("TODO");
  }

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

/// Information about a single Plyta Tygodnia entry.
class PlytaTygodniaInfo {
  /// Creates an empty [PlytaTygodniaInfo] object.
  PlytaTygodniaInfo.empty()
      : artist = '',
        title = '',
        description = '',
        imageTag = 0;

  /// Creates a [PlytaTygodniaInfo] object from a given Json map.
  PlytaTygodniaInfo.fromJson(Map<String, dynamic> jsonData)
      : artist = (jsonData['acf'] as Map<String, dynamic>)['artist'] as String,
        title = (jsonData['acf'] as Map<String, dynamic>)['title'] as String,
        description =
            (jsonData['acf'] as Map<String, dynamic>)['description'] as String,
        imageTag = (jsonData['acf'] as Map<String, dynamic>)['image'] as int;

  final String artist;
  final String title;
  final String description;
  final int imageTag;

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

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class PlytaTygodniaPage extends HookWidget {
  const PlytaTygodniaPage({
    super.key,
    this.timeout = const Duration(seconds: 7),
  });

  final Duration timeout;

  final EdgeInsets _textPadding = const EdgeInsets.symmetric(horizontal: 7);
  final SizedBox _emptySpace = const SizedBox(height: 9);
  final EdgeInsets _pagePadding = const EdgeInsets.only(
    top: 26,
    left: 26,
    right: 26,
  );

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
    final controller = useRefreshableFetchController(
      PlytaTygodniaInfo.empty(),
      _fetchPlytaTygodnia,
    );

    return RefreshableFetchWidget(
      controller: controller,
      // TODO: change Placeholder widgets to actual
      // TODO: widgets for noData and waiting cases
      childWaiting: const Placeholder(),
      childNoData: const Placeholder(),
      child: Padding(
        padding: _pagePadding,
        child: ListView(
          children: [
            Image.network(
              controller.state.value.imageTag,
            ),
            _emptySpace,
            Container(
              height: 31,
              color: context.colors.backgroundDark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _textPadding,
                    child: Text(
                      '${controller.state.value.artist} - ${controller.state.value.title}',
                      style: context.textStyles.textMedium.copyWith(
                        color: context.colors.backgroundLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _emptySpace,
            Padding(
              padding: _textPadding,
              child: Text(
                controller.state.value.description,
                style: context.textStyles.textSmall.copyWith(
                  color: context.colors.backgroundDark,
                ),
              ),
            ),
          ],
        ),
      ),
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
        imageTag = ((jsonData['acf'] as Map<String, dynamic>)['image'] as int)
            .toString();

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

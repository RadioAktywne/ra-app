import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/build_context.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class PlytaTygodniaPage extends HookWidget {
  const PlytaTygodniaPage({
    super.key,
    this.timeout = const Duration(seconds: 10),
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
    try {
      final data = await fetchData(
        _infoUrl,
        PlytaTygodniaInfo.fromJson,
        headers: _infoHeaders,
        timeout: timeout,
      );

      final plytaTygodnia = data.first;

      final imageUrlId = plytaTygodnia.imageTag;
      final imageUrls = await fetchData(
        _imgUrl(imageUrlId),
        (e) => (e['guid'] as Map<String, dynamic>)['rendered'] as String,
        headers: _imgHeaders,
        timeout: timeout,
      );

      final imageUrl = imageUrls.first;
      plytaTygodnia.imageTag = imageUrl;

      return plytaTygodnia;
    } on TimeoutException catch (_) {
      return PlytaTygodniaInfo.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      fetchFunction: _fetchPlytaTygodnia,
      defaultData: PlytaTygodniaInfo.empty(),
      loadingBuilder: (context, snapshot) => const _PlytaTygodniaWaiting(),
      errorBuilder: (context) =>
          _PlytaTygodniaNoData(pagePadding: _pagePadding),
      childBuilder: (context, data) => Padding(
        padding: _pagePadding,
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                data.imageTag,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Container(
                            color: context.colors.backgroundDarkSecondary,
                            child: Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: context.colors.highlightGreen,
                                  strokeWidth: 5,
                                ),
                              ),
                            ),
                          ),
                errorBuilder: (context, child, loadingProgress) => Center(
                  child: Text(
                    'Wystąpił błąd podczas pobierania obrazu',
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
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
                    child: SelectableText(
                      '${data.artist} - ${data.title}',
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
              child: SelectableText(
                data.description,
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

class _PlytaTygodniaNoData extends StatelessWidget {
  const _PlytaTygodniaNoData({
    required this.pagePadding,
  });

  final EdgeInsets pagePadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            maxHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: pagePadding.copyWith(top: 0),
              child: Text(
                'Wystąpił błąd podczas pobierania danych',
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.highlightGreen,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlytaTygodniaWaiting extends StatelessWidget {
  const _PlytaTygodniaWaiting();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.highlightGreen,
        strokeWidth: 5,
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

  bool get isNotEmpty =>
      artist != '' && title != '' && description != '' && imageTag != '';

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

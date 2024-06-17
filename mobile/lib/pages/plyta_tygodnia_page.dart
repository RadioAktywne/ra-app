import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/plyta_tygodnia_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

class PlytaTygodniaPage extends StatelessWidget {
  const PlytaTygodniaPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  /// Fetch timeout
  final Duration timeout;

  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);
  static const EdgeInsets _pagePadding = EdgeInsets.only(left: 26, right: 26);

  /// Space between widgets on page
  static const SizedBox _betweenPadding = SizedBox(height: 9);

  /// Space before or after widgets on page
  static const SizedBox _verticalPadding = SizedBox(height: 26);

  /// Plyta tygodnia info fetch details.
  static final Uri _infoUrl = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/album?page=1&per_page=16',
  );
  static const _infoHeaders = {'Content-Type': 'application/json'};

  /// Plyta tygodnia album cover fetch details.
  static Uri _imgUrl(String id) => Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/media?include[]=$id',
      );
  static const _imgHeaders = {'Content-Type': 'image/jpeg'};

  /// Fetch current Plyta tygodnia from radioaktywne.pl api.
  Future<PlytaTygodniaInfo> _fetchPlytaTygodnia() async {
    try {
      final data = await fetchData(
        _infoUrl,
        PlytaTygodniaInfo.fromJson,
        headers: _infoHeaders,
        timeout: timeout,
      );

      final plytaTygodnia = data.first;

      final imageUrls = await fetchData(
        _imgUrl(plytaTygodnia.imageTag),
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
      onFetch: _fetchPlytaTygodnia,
      defaultData: PlytaTygodniaInfo.empty(),
      loadingBuilder: (context, snapshot) => const _PlytaTygodniaWaiting(),
      errorBuilder: (context) => const _PlytaTygodniaNoData(),
      builder: (context, plytaTygodnia) => Padding(
        padding: _pagePadding,
        child: ListView(
          children: [
            _verticalPadding,
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                plytaTygodnia.imageTag,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? FittedBox(
                            fit: BoxFit.fitWidth,
                            clipBehavior: Clip.hardEdge,
                            child: child,
                          )
                        : Container(
                            color: context.colors.backgroundDarkSecondary,
                            child: const RaProgressIndicator(),
                          ),
                errorBuilder: (context, child, loadingProgress) => Center(
                  child: Text(
                    context.l10n.imageLoadError,
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.highlightGreen,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
            _betweenPadding,
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
                      '${plytaTygodnia.artist} - ${plytaTygodnia.title}',
                      style: context.textStyles.textMedium.copyWith(
                        color: context.colors.backgroundLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _betweenPadding,
            Padding(
              padding: _textPadding,
              child: SelectableText(
                plytaTygodnia.description + plytaTygodnia.description,
                style: context.textStyles.textSmall.copyWith(
                  color: context.colors.backgroundDark,
                ),
              ),
            ),
            _verticalPadding,
          ],
        ),
      ),
    );
  }
}

/// Empty variant of the [PlytaTygodniaPage], to be
/// displayed when data cannot be fetched.
class _PlytaTygodniaNoData extends StatelessWidget {
  const _PlytaTygodniaNoData();

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
              padding: PlytaTygodniaPage._pagePadding.copyWith(top: 0),
              child: Text(
                context.l10n.dataLoadError,
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

/// Loading variant of [PlytaTygodniaPage], displaying
/// loading animation.
class _PlytaTygodniaWaiting extends StatelessWidget {
  const _PlytaTygodniaWaiting();

  @override
  Widget build(BuildContext context) {
    return const RaProgressIndicator();
  }
}

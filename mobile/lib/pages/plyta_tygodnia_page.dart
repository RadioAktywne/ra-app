import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/plyta_tygodnia_info.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/resources.dart';

/// Page displaying the album of the week.
// TODO: merge UI with `lib/pages/article_page`
class PlytaTygodniaPage extends StatelessWidget {
  const PlytaTygodniaPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  /// Fetch timeout
  final Duration timeout;

  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);

  /// Space between widgets on page
  static const SizedBox _betweenPadding = SizedBox(height: 9);

  /// Space before or after widgets on page
  static const SizedBox _verticalPadding = SizedBox(height: 26);

  /// Plyta tygodnia info fetch details.
  static final Uri _infoUrl = Uri.https(
    RaApi.baseUrl,
    RaApi.endpoints.album,
    {
      'page': 1,
      'per_page': 1,
    }.valuesToString(),
  );
  static const _infoHeaders = {'Content-Type': 'application/json'};

  /// Plyta tygodnia album cover fetch details.
  static Uri _imgUrl(String id) => Uri.https(
        RaApi.baseUrl,
        '${RaApi.endpoints.media}/$id',
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

      plytaTygodnia.imageTag = await fetchSingle(
        _imgUrl(plytaTygodnia.imageTag),
        (e) => (e['guid'] as Map<String, dynamic>)['rendered'] as String,
        headers: _imgHeaders,
        timeout: timeout,
      );

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
      hasData: (plytaTygodnia) => plytaTygodnia.isNotEmpty,
      loadingBuilder: (context, snapshot) => const RaProgressIndicator(),
      errorBuilder: (context) => const RaErrorPage(),
      builder: (context, plytaTygodnia) => Padding(
        padding: RaPageConstraints.outerTextPagePadding,
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
              color: context.colors.backgroundDark,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaddingHtmlWidget(
                    style: context.textStyles.textMedium.copyWith(
                      color: context.colors.backgroundLight,
                    ),
                    htmlContent:
                        '${plytaTygodnia.artist} - ${plytaTygodnia.title}',
                  ),
                ),
              ),
            ),
            _betweenPadding,
            Padding(
              padding: _textPadding,
              child: SelectableText(
                plytaTygodnia.description + plytaTygodnia.description,
                style: context.textStyles.textSmallGreen.copyWith(
                  color: context.colors.backgroundDark,
                ),
              ),
            ),
            SizedBox(height: context.playerPaddingValue),
          ],
        ),
      ),
    );
  }
}

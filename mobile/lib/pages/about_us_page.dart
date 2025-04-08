import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/custom_padding_html_widget.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/l10n/localizations_pl.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';
import 'package:radioaktywne/resources/resources.dart';

import '../models/about_us_info.dart';

/// Page displaying the album of the week.
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({
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

  /// About us info fetch details.
  static final Uri _infoUrl = Uri.https(
    RaApi.baseUrl,
    RaApi.endpoints.about,
    {
      'page': 1,
      'per_page': 1,
    }.valuesToString(),
  );
  static const _infoHeaders = {'Content-Type': 'application/json'};

  /// Fetch About Us from radioaktywne.pl api.
  Future<AboutUsInfo> _fetchAboutUs() async {
    try {
      final data = await fetchData(
        _infoUrl,
        AboutUsInfo.fromJson,
        headers: _infoHeaders,
        timeout: timeout,
      );

      final aboutUs = data.first;


      return aboutUs;
    } on TimeoutException catch (_) {
      return AboutUsInfo.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      onFetch: _fetchAboutUs,
      defaultData: AboutUsInfo.empty(),
      hasData: (aboutUs) => aboutUs.isNotEmpty,
      loadingBuilder: (context, snapshot) => const RaProgressIndicator(),
      errorBuilder: (context) => const RaErrorPage(),
      builder: (context, aboutUs) => Padding(
        padding: RaPageConstraints.outerTextPagePadding,
        child: ListView(
          children: [
            _verticalPadding,
            Container(
              color: context.colors.backgroundDark,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: RaPageConstraints.textPageTitlePadding,
                  child: SelectableText(
                    context.l10n.aboutUs,
                    style: context.textStyles.textPlayer
                  ),
                ),
              ),
            ),
            _betweenPadding,
            Padding(
              padding: _textPadding,
              child: CustomPaddingHtmlWidget(
                style: context.textStyles.textMedium.copyWith(
                  color: context.colors.backgroundDark,
                ),
                htmlContent:
                aboutUs.content,
              ),

            ),
            SizedBox(height: context.playerPaddingValue),
          ],
        ),
      ),
    );
  }
}

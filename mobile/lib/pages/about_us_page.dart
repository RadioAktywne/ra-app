import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/about_us_info.dart';
import 'package:radioaktywne/pages/templates/ra_page_template.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/resources.dart';

/// Page displaying info about us.
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  /// Fetch timeout
  final Duration timeout;

  /// About us info fetch details.
  static final _infoUrl = Uri.https(
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
    return RaPageTemplate(
      onFetch: _fetchAboutUs,
      defaultData: AboutUsInfo.empty(),
      hasData: (aboutUsInfo) => aboutUsInfo.isNotEmpty,
      itemBuilder: (aboutUsInfo) => RaPageTemplateItem(
        image: 'assets/ra_logo/RA_logo.png',
        content: aboutUsInfo.content,
      ),
    );
  }
}

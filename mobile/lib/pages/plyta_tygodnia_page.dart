import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/plyta_tygodnia_info.dart';
import 'package:radioaktywne/pages/templates/ra_page_template.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';
import 'package:radioaktywne/resources/resources.dart';

/// Page displaying the album of the week.
class PlytaTygodniaPage extends StatelessWidget {
  const PlytaTygodniaPage({
    super.key,
    this.timeout = const Duration(seconds: 15),
  });

  /// Fetch timeout
  final Duration timeout;

  /// Plyta tygodnia info fetch details.
  static final _infoUrl = Uri.https(
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
    } on TimeoutException catch (e, stackTrace) {
      if (kDebugMode) {
        print('HANDLED: $stackTrace: $e');
      }
      return PlytaTygodniaInfo.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaPageTemplate(
      onFetch: _fetchPlytaTygodnia,
      defaultData: PlytaTygodniaInfo.empty(),
      hasData: (plytaTygodnia) => plytaTygodnia.isNotEmpty,
      itemBuilder: (plytaTygodnia) => RaPageTemplateItem(
        imagePath: plytaTygodnia.imageTag,
        title: '${plytaTygodnia.artist} - ${plytaTygodnia.title}',
        content: plytaTygodnia.description,
      ),
    );
  }
}

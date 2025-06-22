import 'dart:async';

import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';

/// A convenient wrapper around [fetchData] for fetching
/// all of Ramowka.
Future<Iterable<RamowkaInfo>> fetchRamowka({
  Duration timeout = const Duration(seconds: 7),
}) =>
    fetchData(
      Uri.https(
        RaApi.baseUrl,
        RaApi.endpoints.event,
        {
          '_embed': true,
          'page': 1,
          'per_page': 100,
        }.valuesToString(),
      ),
      RamowkaInfo.fromJson,
      timeout: timeout,
      headers: {'Content-Type': 'application/json'},
    );

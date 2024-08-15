import 'dart:async';

import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_links.dart';

/// A conviniance wrapper around [fetchData] for fetching
/// all of Ramowka.
Future<Iterable<RamowkaInfo>> fetchRamowka({
  Duration timeout = const Duration(seconds: 7),
}) async =>
    fetchData(
      Uri.https(
        RaLinks.radioAktywne,
        RaLinks.api.event,
        {
          '_embed': true.toString(),
          'page': 1.toString(),
          'per_page': 100.toString(),
        },
      ),
      RamowkaInfo.fromJson,
      timeout: timeout,
      headers: {'Content-Type': 'application/json'},
    );

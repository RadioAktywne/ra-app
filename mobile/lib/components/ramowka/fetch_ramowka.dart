import 'dart:async';

import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

final Uri url = Uri.parse(
  'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
);
const headers = {'Content-Type': 'application/json'};

/// A conviniance wrapper around [fetchData] for fetching
/// all of Ramowka.
Future<Iterable<RamowkaInfo>> fetchRamowka({
  Duration timeout = const Duration(seconds: 7),
}) async =>
    fetchData(
      url,
      RamowkaInfo.fromJson,
      timeout: timeout,
      headers: headers,
    );

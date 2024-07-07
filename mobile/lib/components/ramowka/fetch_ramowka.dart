import 'dart:async';

import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

final Uri url = Uri.parse(
  'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
);
const headers = {'Content-Type': 'application/json'};

Future<Iterable<RamowkaInfo>> fetchRamowka({Duration? timeout}) async {
  final data = await fetchData(
    url,
    RamowkaInfo.fromJson,
    timeout: timeout ?? const Duration(seconds: 7),
    headers: headers,
  );

  return data;
}

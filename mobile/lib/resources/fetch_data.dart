import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches the data from provided source [url]
/// and bundles it into a form of an iterable
/// of a provided type.
///
/// The [fromJson] function has to be a function
/// that converts the provided JSON data to
/// an object of the implementer type. In other
/// words, it's a JSON constructor.
Future<Iterable<T>> fetchData<T>(
  Uri url,
  T Function(Map<String, dynamic>) fromJson, {
  Duration timeout = const Duration(seconds: 5),
  Map<String, String> headers = const {},
}) async {
  final response = await http
      .get(
        url,
        headers: headers,
      )
      .timeout(timeout);

  final jsonData = jsonDecode(response.body) as List<dynamic>;

  return jsonData.map(
    (dynamic data) => fromJson(data as Map<String, dynamic>),
  );
}

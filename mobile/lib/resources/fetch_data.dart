import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches the data from provided source [url]
/// and bundles it into a form of an iterable
/// of a provided type [T].
///
/// The [fromJson] has to be a function
/// that converts the provided JSON data to
/// an object of type [T].
/// For example, it can be [T]'s fromJson()
/// constructor.
///
/// Throws [TimeoutException] if the fetching
/// function exceeds given [timeout].
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

  try {
    final jsonData = jsonDecode(response.body) as List<dynamic>;
    return jsonData.map(
      (data) => fromJson(data as Map<String, dynamic>),
    );
  } catch (e) {
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return [fromJson(jsonData)];
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const _jsonHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

const _fetchTimeout = Duration(seconds: 7);

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
  Duration timeout = _fetchTimeout,
  Map<String, String> headers = _jsonHeaders,
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

/// Fetches the data from provided source [url]
/// and bundles it into a form of an object of type [T].
///
/// The [fromJson] has to be a function
/// that converts the provided JSON data to
/// an object of type [T].
/// For example, it can be [T]'s fromJson()
/// constructor.
///
/// Throws [TimeoutException] if the fetching
/// function exceeds given [timeout].
Future<T> fetchSingle<T>(
  Uri url,
  T Function(Map<String, dynamic>) fromJson, {
  Duration timeout = _fetchTimeout,
  Map<String, String> headers = _jsonHeaders,
}) async {
  final response = await http
      .get(
        url,
        headers: headers,
      )
      .timeout(timeout);

  final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
  return fromJson(jsonData);
}

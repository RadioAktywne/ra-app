import 'dart:async';

import 'package:dio/dio.dart';
import 'package:radioaktywne/network/http.dart';

const _jsonHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

const _fetchTimeout = Duration(seconds: 7);

/// Fetches the data from provided source [url] and bundles it into a form of
/// an object of type [T].
///
/// The [fromJson] has to be a function that converts the provided JSON data to
/// an object of type [T]. For example, it can be [T]'s fromJson() constructor.
///
/// Throws [TimeoutException] if the fetching function exceeds given [timeout].
Future<T> fetchObject<T>(
  Uri url,
  T Function(Map<String, dynamic>) fromJson, {
  Duration timeout = _fetchTimeout,
  Map<String, dynamic> headers = _jsonHeaders,
  dynamic onEmpty,
}) async {
  final response = await raHttpClient
      .getUri<dynamic>(url, options: Options(headers: headers))
      .timeout(timeout);

  onEmpty ??= <String, dynamic>{};
  final jsonData = (response.data ?? onEmpty) as Map<String, dynamic>;
  return fromJson(jsonData);
}

/// Fetches the data from provided source [url] and bundles it into a form of
/// an iterable of objects of type [T].
///
/// The [fromJson] has to be a function that converts the provided JSON data to
/// an object of type [T]. For example, it can be [T]'s fromJson() constructor.
///
/// Throws [TimeoutException] if the fetching function exceeds given [timeout].
Future<Iterable<T>> fetchList<T>(
  Uri url,
  T Function(Map<String, dynamic>) fromJson, {
  Duration timeout = _fetchTimeout,
  Map<String, dynamic> headers = _jsonHeaders,
  dynamic onEmpty,
}) async {
  final response = await raHttpClient
      .getUri<dynamic>(url, options: Options(headers: headers))
      .timeout(timeout);

  onEmpty ??= <dynamic>[];
  final jsonData = (response.data ?? onEmpty) as List<dynamic>;
  return jsonData.map(
    (data) => fromJson(data as Map<String, dynamic>),
  );
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

late Dio raHttpClient;

/// To be called on app startup to initialize the HTTP client
Future<void> initRAHttp() async {
  final sc = SecurityContext();
  // TODO: What if this fails? Should we just use
  // TODO: [SecurityContext.defaultContext] instead?
  final certificates =
      await rootBundle.load('assets/certificates/radioaktywne.crt');
  sc.setTrustedCertificatesBytes(certificates.buffer.asUint8List());
  final dio = Dio();

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    return HttpClient(context: sc);
  };

  raHttpClient = dio;
}

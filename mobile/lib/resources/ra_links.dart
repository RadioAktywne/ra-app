abstract class RaRadio {
  static const String baseUrl = 'listen.radioaktywne.pl';
  static const String status = 'status-json.xsl';
  static const String radioStream = 'raogg';  // TODO: add low-fi radio stream (ramp4)
}

abstract class RaApi {
  static const String baseUrl = 'radioaktywne.pl';
  static const String logoUrl =
      'https://cdn-profiles.tunein.com/s10187/images/logod.png';
  static const _RadioAktywneApi endpoints = _RadioAktywneApi._();
}

class _RadioAktywneApi {
  const _RadioAktywneApi._();

  static const String _api = 'wp-json/wp/v2';

  String get posts => '$_api/posts';
  String get event => '$_api/event';
  String get album => '$_api/album';
  String get media => '$_api/media';
  String get recording => '$_api/recording';
}
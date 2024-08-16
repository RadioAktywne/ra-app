abstract class RaListen {
  static const int playerPort = 8443;

  static const String baseUrl = 'listen.radioaktywne.pl:$playerPort';
  static const String status = 'status-json.xsl';
  static const String radioStream = 'raogg';
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

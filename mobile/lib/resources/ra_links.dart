abstract class RaRadio {
  static const radioPort = 443;
  static const baseUrl = 'listen.radioaktywne.pl:$radioPort';
  static const status = 'status-json.xsl';
  static const radioStream = 'raogg';
  // TODO: add low-fi radio stream (ramp3)
}

abstract class RaApi {
  static const baseUrl = 'radioaktywne.pl';
  static const logoUrl =
      'https://cdn-profiles.tunein.com/s10187/images/logod.png';
  static const endpoints = _RadioAktywneApi._();
}

class _RadioAktywneApi {
  const _RadioAktywneApi._();

  static const _api = 'wp-json/wp/v2';

  String get posts => '$_api/posts';
  String get event => '$_api/event';
  String get album => '$_api/album';
  String get media => '$_api/media';
  String get recording => '$_api/recording';
  String get about => '$_api/pages';

  String post(int id) => '$posts/$id';
}

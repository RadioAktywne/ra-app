abstract class RaLinks {
  static const int playerPort = 8443;
  static const String radioAktywne = 'radioaktywne.pl';
  static const _RadioAktywneApi api = _RadioAktywneApi._();
  static const String radioPlayerBase =
      'listen.radioaktywne.pl:${RaLinks.playerPort}';
  static const _RadioPlayerBase radioPlayer = _RadioPlayerBase._();
  static const String logo =
      'https://cdn-profiles.tunein.com/s10187/images/logod.png';
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

class _RadioPlayerBase {
  const _RadioPlayerBase._();

  String get status => 'status-json.xsl';
  String get radioStream => 'raogg';
}

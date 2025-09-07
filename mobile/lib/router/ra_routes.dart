abstract class RaRoutes {
  const RaRoutes._();

  static const home = '/home';
  static const recordings = '/recordings';
  static const albumOfTheWeek = '/albumOfTheWeek';
  static const articles = '/articles';
  static const radioPeople = '/radioPeople';
  static const ramowka = '/ramowka';
  static const broadcasts = '/broadcasts';
  static const about = '/about';
  static const article = '/article/:id';
  static const recording = '/recording/:id';

  static String articleId(int id) => '/article/$id';
  static String recordingId(int id) => '/recording/$id';
}

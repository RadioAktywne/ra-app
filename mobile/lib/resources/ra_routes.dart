abstract class RaRoutes {
  const RaRoutes._();

  static const String home = '/home';
  static const String recordings = '/recordings';
  static const String albumOfTheWeek = '/album';
  static const String articles = '/articles';
  static const String radioPeople = '/radioPeople';
  static const String ramowka = '/ramowka';
  static const String broadcasts = '/broadcasts';
  static const String about = '/about';
  static const String article = '/article/:id';

  static String articleId(int id) => '/article/$id';
}

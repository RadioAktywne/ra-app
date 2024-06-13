import 'localizations.dart';

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get hello => 'cześć';

  @override
  String get dataLoadError => 'Wystąpił błąd podczas pobierania danych';

  @override
  String get imageLoadError => 'Wystąpił błąd podczas pobierania obrazu';

  @override
  String get noStreamTitle => 'Radio Aktywne';

  @override
  String get ramowka => 'Ramówka';
}

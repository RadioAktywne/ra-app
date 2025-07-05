import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// No description provided for @hello.
  ///
  /// In pl, this message translates to:
  /// **'cześć'**
  String get hello;

  /// No description provided for @radio.
  ///
  /// In pl, this message translates to:
  /// **'Radio'**
  String get radio;

  /// No description provided for @recording.
  ///
  /// In pl, this message translates to:
  /// **'Nagranie'**
  String get recording;

  /// No description provided for @dataLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd podczas pobierania danych'**
  String get dataLoadError;

  /// No description provided for @imageLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd podczas pobierania obrazu'**
  String get imageLoadError;

  /// No description provided for @noStreamTitle.
  ///
  /// In pl, this message translates to:
  /// **'Radio Aktywne'**
  String get noStreamTitle;

  /// No description provided for @ramowka.
  ///
  /// In pl, this message translates to:
  /// **'Ramówka'**
  String get ramowka;

  /// No description provided for @monday.
  ///
  /// In pl, this message translates to:
  /// **'Poniedziałek'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In pl, this message translates to:
  /// **'Wtorek'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In pl, this message translates to:
  /// **'Środa'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In pl, this message translates to:
  /// **'Czwartek'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In pl, this message translates to:
  /// **'Piątek'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In pl, this message translates to:
  /// **'Sobota'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In pl, this message translates to:
  /// **'Niedziela'**
  String get sunday;

  /// No description provided for @nowPlaying.
  ///
  /// In pl, this message translates to:
  /// **'Teraz gramy'**
  String get nowPlaying;

  /// No description provided for @backToRadio.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do radia'**
  String get backToRadio;

  /// No description provided for @backToMainPage.
  ///
  /// In pl, this message translates to:
  /// **'wróć na stronę główną'**
  String get backToMainPage;

  /// No description provided for @aboutUs.
  ///
  /// In pl, this message translates to:
  /// **'O nas'**
  String get aboutUs;

  /// No description provided for @newestArticles.
  ///
  /// In pl, this message translates to:
  /// **'Najnowsze artykuły'**
  String get newestArticles;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

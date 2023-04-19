import 'package:flutter/material.dart';
import 'package:radioaktywne/l10n/localizations.dart';

extension BuildContextLocalizations on BuildContext {
  Locale get locale => Localizations.localeOf(this);

  String get languageCode => locale.toLanguageTag();

  AppLocalizations get l10n => AppLocalizations.of(this)!;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}

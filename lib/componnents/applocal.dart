import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This class will handle localization logic.
class AppLocale {
  final Locale locale;

  AppLocale(this.locale);

  late Map<String, String> _loadedLocalizedValues;

  // Method to access localization instance.
  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale)!;
  }

  // Loads localization files based on the language code.
  Future<void> loadLang() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // Maps JSON data into a Map<String, String>
    _loadedLocalizedValues =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  // Fetches translated text for a given key.
  String? getTranslated(String key) {
    return _loadedLocalizedValues[key];
  }

  // Localization delegate to load and switch between languages.
  static const LocalizationsDelegate<AppLocale> delegate = _AppLocalDelegate();
}

// Localizations delegate to load JSON files based on locale.
class _AppLocalDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocalDelegate();

  @override
  bool isSupported(Locale locale) => ["en", "ar"].contains(locale.languageCode);

  @override
  Future<AppLocale> load(Locale locale) async {
    AppLocale localizations = AppLocale(locale);
    await localizations.loadLang();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocale> old) => false;
}

// Helper function to fetch localized text.
String getLang(BuildContext context, String key) {
  return AppLocale.of(context).getTranslated(key) ?? key;
}

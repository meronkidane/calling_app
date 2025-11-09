import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations._(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('am', 'ET'),
    Locale('ti', 'ER'),
  ];

  static const localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final withCountry = (locale.countryCode?.isNotEmpty ?? false)
        ? '${locale.languageCode}_${locale.countryCode}'
        : null;

    final fallbackOrder = <String>[
      if (withCountry != null) withCountry,
      locale.languageCode,
      'en_US',
    ];

    Map<String, String>? strings;
    for (final candidate in fallbackOrder) {
      final assetPath = 'assets/i18n/$candidate.json';
      try {
        final jsonString = await rootBundle.loadString(assetPath);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        strings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        break;
      } on FlutterError {
        continue;
      }
    }

    strings ??= const {};
    return AppLocalizations._(locale, strings);
  }

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'AppLocalizations has not been initialized.');
    return result!;
  }

  String translate(
    String key, {
    Map<String, String>? params,
  }) {
    var value = _strings[key] ?? key;
    if (params != null) {
      params.forEach((placeholder, replacement) {
        value = value.replaceAll('{$placeholder}', replacement);
      });
    }
    return value;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}

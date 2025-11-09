import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:calling_app/src/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallingApp extends ConsumerWidget {
  const CallingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final supportedLocales = AppLocalizations.supportedLocales;
    final delegates = AppLocalizations.localizationsDelegates;

    Locale? resolveLocale(Locale? locale, Iterable<Locale> supported) {
      if (locale == null) return supported.first;
      return supported.firstWhere(
        (supportedLocale) =>
            supportedLocale.languageCode == locale.languageCode &&
            supportedLocale.countryCode == locale.countryCode,
        orElse: () => supported.firstWhere(
          (supportedLocale) =>
              supportedLocale.languageCode == locale.languageCode,
          orElse: () => supported.first,
        ),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoApp.router(
        routerConfig: router,
        localizationsDelegates: delegates,
        supportedLocales: supportedLocales,
        onGenerateTitle: (context) => context.loc.translate('app_title'),
        localeResolutionCallback: resolveLocale,
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
          brightness: Brightness.light,
        ),
      );
    }

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: delegates,
      supportedLocales: supportedLocales,
      onGenerateTitle: (context) => context.loc.translate('app_title'),
      localeResolutionCallback: resolveLocale,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
    );
  }
}

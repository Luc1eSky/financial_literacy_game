import 'dart:ui';

import 'package:flutter/material.dart';

import '../domain/utils/device_and_personal_data.dart';

class L10n {
  static const defaultLocale = Locale('en', 'US');

  static final all = [
    defaultLocale,
    //const Locale('kn', 'IN'),
    // const Locale('lg'),
    const Locale('es', 'PE'),
    // const Locale('es', 'GT')
  ];

  static Future<Locale> getSystemLocale() async {
    // try to load saved locale from local memory
    Locale? loadedLocale = await loadLocaleFromLocal();

    if (loadedLocale != null) {
      return loadedLocale;
    }

    // get default locale from system
    Locale systemLocale = window.locale;
    debugPrint(
        'System locale: ${systemLocale.languageCode} / ${systemLocale.countryCode}');

    // use system locale only if supported
    if (L10n.all.contains(systemLocale)) {
      debugPrint('System locale supported.');
      return systemLocale;
    }
    // otherwise use default locale
    debugPrint('System locale not supported, using default locale:'
        '${defaultLocale.languageCode} / ${defaultLocale.countryCode}');
    return L10n.defaultLocale;
  }

  static double getConversionRate(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 1;
      case 'lg':
        return 4000;
      case 'kn':
        return 80;
      default:
        return 1;
    }
  }
}

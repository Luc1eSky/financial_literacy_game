import 'dart:ui';

import 'package:flutter/material.dart';

class L10n {
  static const defaultLocale = Locale('en', 'US');

  static final all = [
    defaultLocale,
    const Locale('de', 'DE'),
    const Locale('fr', 'FR'),
  ];

  static Locale getSystemLocale() {
    // get default locale from system
    Locale systemLocale = window.locale;
    debugPrint('System locale: ${systemLocale.languageCode} / ${systemLocale.countryCode}');

    // use system locale only if supported
    if (L10n.all.contains(systemLocale)) {
      return systemLocale;
    }
    // otherwise use default locale
    else {
      debugPrint('System locale not supported, using default locale:'
          '${defaultLocale.languageCode} / ${defaultLocale.countryCode}');
      return L10n.defaultLocale;
    }
  }
}

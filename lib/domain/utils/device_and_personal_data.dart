import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../concepts/person.dart';
import '../game_data_notifier.dart';

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    debugPrint('Running on ${webBrowserInfo.userAgent}');
  }
}

Future<bool> loadPerson({required WidgetRef ref}) async {
  final prefs = await SharedPreferences.getInstance();
  String? savedFirstName = prefs.getString('firstName');
  String? savedLastName = prefs.getString('lastName');

  if (savedFirstName == null || savedLastName == null) return false;

  debugPrint('Loaded person $savedFirstName $savedLastName from local storage.');
  Person loadedPerson = Person(firstName: savedFirstName, lastName: savedLastName);
  ref.read(gameDataNotifierProvider.notifier).setPerson(loadedPerson);
  return true;
}

void savePersonLocally(Person person) async {
  debugPrint('Save person ${person.firstName} ${person.lastName} to local storage.');
  if (person.exists()) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', person.firstName!);
    prefs.setString('lastName', person.lastName!);
  }
}

Future<bool> loadLevelIDFromLocal({required WidgetRef ref}) async {
  final prefs = await SharedPreferences.getInstance();
  int? savedLastPlayedLevelID = prefs.getInt('lastPlayedLevelID');

  if (savedLastPlayedLevelID == null) {
    return false;
  } else {
    ref.read(gameDataNotifierProvider.notifier).loadLevel(savedLastPlayedLevelID);
    return true;
  }
}

void saveLevelIDLocally(int levelID) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('lastPlayedLevelID', levelID);
}

void saveLocalLocally(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('languageCode', locale.languageCode);
  if (locale.countryCode != null) {
    prefs.setString('countryCode', locale.countryCode!);
  }
}

Future<Locale?> loadLocaleFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  String? countryCode = prefs.getString('countryCode');

  if (languageCode == null || countryCode == null) {
    return null;
  } else {
    Locale loadedLocale = Locale(languageCode, countryCode);
    return loadedLocale;
  }
}

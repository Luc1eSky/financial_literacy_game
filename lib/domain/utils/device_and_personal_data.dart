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

  Person loadedPerson = Person(firstName: savedFirstName, lastName: savedLastName);
  ref.read(gameDataNotifierProvider.notifier).setPerson(loadedPerson);
  return true;
}

void savePerson(Person person) async {
  if (person.exists()) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', person.firstName!);
    prefs.setString('lastName', person.lastName!);
  }
}

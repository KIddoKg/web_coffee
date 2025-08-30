import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:xanh_coffee/services/notification_services.dart';
import 'app.dart';
import 'config/env.dart';
import 'config/flavor.dart';
import 'helper/di/di.dart';

//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }
void main() async {
  // First, ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationManager.instance.init();
  // NotificationManager.instance.main();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize other required services
  await initDI(ENVType.uat);

  // Wrap the FluConsole.run() outside of runZonedGuarded to ensure it's in the same zone
  // FluConsole.run(() {
    runApp(MyApp(shouldShowDebugButton: Flavor.flavorType.isDev));
  // }, enableLog: true);

  // Optionally, you could have `runZonedGuarded()` for additional error handling if necessary:
  runZonedGuarded(() {
    // Your zone-specific operations, logging, etc. if needed
  }, (error, trace) {
    log('[DEV] Error while running app', time: DateTime.now(), error: error, stackTrace: trace);
  });
}

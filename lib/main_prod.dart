import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:xanh_coffee/config/flavor.dart';
import 'app.dart';
import 'config/env.dart';
import 'helper/di/di.dart';

// Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
//   AppLog.info('FCM received data when app in the background: ${message.data}');
// }

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initDI(ENVType.prod);

    // if (Platform.isIOS) {
    //   Firebase.initializeApp(); // Avoid iOS release build hang
    // } else {
    //   await Firebase.initializeApp();
    // }

    // await di<NotificationUtil>().init();

    // final FCMUtil fcmUtil = di();
    // fcmUtil.getToken().then((fcmToken) => log('FCM TOKEN: $fcmToken'));

    // final NotificationUtil notificationUtil = di();

    // fcmUtil.onMessage().listen((RemoteMessage event) {
    //   AppLog.info(
    //       'FCM received data when app visible on the screen: ${event.data}');
    //   final NotificationData notificationData =
    //       NotificationData.fromJson(event.data);

    //   notificationUtil.show(notificationData);
    // });

    // fcmUtil.onMessageOpenedApp().listen((RemoteMessage event) {
    //   AppLog.info(
    //       'FCM received data when open app via notification from background: ${event.data}');
    //   // final NotificationData notificationData =
    //   //     NotificationData.fromJson(event.data);
    // });

    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

    runApp(MyApp(shouldShowDebugButton: Flavor.flavorType.isDev));
  }, (error, trace) {
    log('[DEV] Error while running app', time: DateTime.now(),error:  error, stackTrace: trace);
  });
}

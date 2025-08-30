import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:xanh_coffee/services/notification_services.dart';

import 'app.dart';
import 'config/env.dart';
import 'config/flavor.dart';
import 'helper/di/di.dart';
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }
import 'dart:html' as html;
void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await initDI(ENVType.prod);
    // if (Platform.isIOS) {
    //   Firebase.initializeApp(); // Avoid iOS release build hang
    // } else {
    //   await Firebase.initializeApp();
    // }

    // await di<NotificationUtil>().init();

    // final FCMUtil fcmUtil = di();
    // fcmUtil.getToken().then((fcmToken) => AppLog.info('FCM TOKEN: $fcmToken'));

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

    // NotificationManager.instance.init();
    // NotificationManager.instance.main();

    // runApp(
    //   DevicePreview(
    //     enabled: true,
    //     builder: (context) => MyApp(shouldShowDebugButton: Flavor.flavorType.isProd), // Wrap your app
    //   ),
    // );

    runApp(
      MyApp(shouldShowDebugButton: Flavor.flavorType.isProd),
    );
    // Future.delayed(Duration(seconds: 5), () {
    //   final splash = html.document.getElementById('loading-splash');
    //   if (splash != null) {
    //     // Fade-out trước khi xoá
    //     splash.style.transition = 'opacity 0.8s ease-out';
    //     splash.style.opacity = '0';
    //
    //     // Xoá hoàn toàn sau khi fade-out xong
    //     Future.delayed(Duration(milliseconds: 800), () {
    //       splash.remove();
    //     });
    //   }
    // });
    // Lắng nghe khi resize

   await Future.delayed(Duration(seconds: 5), () {
      showSplashFor(Duration(seconds: 1)); // ẩn lần đầu
    });
    html.window.onResize.listen((event) {
      showSplashFor(Duration(seconds: 1)); // mỗi lần resize, hiển splash 1s
    });
  }, (error, trace) {
    log('[DEV] Error while running app', time: DateTime.now(), error: error, stackTrace: trace);
  });
}
void showSplashFor(Duration duration) {
  final splash = html.document.getElementById('loading-splash');

  if (splash != null) {
    // Reset style trước khi hiển
    splash.style
      ..opacity = '1'
      ..display = 'flex'
      ..transition = 'opacity 0.5s ease-out'
      ..transform = 'none' // Chặn scale hoặc hiệu ứng cũ
      ..animation = 'none'; // Nếu có animation CSS, tắt nó đi

    // Sau thời gian delay, ẩn đi
    Future.delayed(duration, () {
      splash.style.opacity = '0';
      Future.delayed(Duration(milliseconds: 500), () {
        splash.style.display = 'none';
      });
    });
  }
}


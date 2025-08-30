// // import 'package:dart_notification_center/dart_notification_center.dart';
// import 'dart:developer';
//
// import 'package:flutter/widgets.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:async';
//
//
// import 'package:permission_handler/permission_handler.dart';
//
// import 'app_lifecycle.dart';
//
// class LocationManager {
//   static final LocationManager instance = LocationManager._internal();
//
//   factory LocationManager() {
//     return instance;
//   }
//
//   LocationManager._internal();
//
//   late Position myLocation;
//   late Position myPrevLocation;
//   late int interval;
//   bool onForeground = true;
//   late StreamSubscription<Position> positionStreamSubscription;
//
//   // Future<void> getIntervalTime() async {
//   //   var json = await AppSettings.getSettings();
//   //   json.forEach((element) {
//   //     SettingModel o = SettingModel.fromJson(element);
//   //     if (o.code == 'Tracking.Interval') {
//   //       interval = int.parse(o.value);
//   //       return;
//   //     }
//   //   });
//   // }
//
//   Future<Map<String, bool>> init() async {
//     LocationManager.instance.onForeground = true;
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     // await getIntervalTime();
//     var statusWhileInUse =  await Geolocator.requestPermission();
//
//     if (statusWhileInUse == LocationPermission.whileInUse && serviceEnabled) {
//       var statusAlways = await Geolocator.requestPermission();
//
//       if (statusAlways == LocationPermission.always || statusAlways == LocationPermission.whileInUse) {
//         // locationChanged();
//         return {'success': true};
//       } else {
//         await openAppSettings();
//         statusAlways = await Geolocator.requestPermission();
//         if (statusAlways != LocationPermission.always) {
//           return {'success':false, 'open_setting': true};
//         }
//         // locationChanged();
//         return {'success': true};
//       }
//     }
//     return {'success': false, 'open_setting': false};
//   }
//
//   locationChanged() async {
//     // DartNotificationCenter.post(channel: 'on_location_changed');
//     // NotificationCenter().notify('on_location_changed');
//     positionStreamSubscription =
//         Geolocator.getPositionStream().listen((Position position) {
//       myLocation = position;
//
//     });
//     WidgetsBinding.instance.addObserver(LifecycleEventHandler(
//       resumeCallBack: () => openApp(),
//     ));
//   }
//
//   Future<Position> openApp() async {
//     myLocation = await Geolocator.getCurrentPosition();
//     print("------------------------------------------");
//     print("from openapp");
//     print(myLocation);
//     print("------------------------------------------");
//     return myLocation;
//   }
//
//   Future<int> checkPermission() async {
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (serviceEnabled) {
//       final permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.always ||
//           permission == LocationPermission.whileInUse) {
//         return 0;
//       } else {
//         return 2;
//       }
//     } else {
//       return 1;
//     }
//   }
//
//   Future<void> setUp() async {
//     // await getIntervalTime();
//   //   Timer.periodic(Duration(seconds: interval), (timer) async {
//   //     myLocation = await Geolocator.getCurrentPosition();
//   //     print('inside setUp');
//   //     print(myLocation);
//   //     await Services.instance
//   //         .logLocation(myLocation.latitude, myLocation.longitude);
//   //   });
//   }
// }

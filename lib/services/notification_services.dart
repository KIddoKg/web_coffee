// // //
// // //
// // // import 'dart:io';
// // // import 'dart:math';
// // //
// // //
// // // import 'package:firebase_messaging/firebase_messaging.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:path_provider/path_provider.dart';
// // //
// // //
// // // class NotificationServices {
// // //
// // //   //initialising firebase message plugin
// // //   FirebaseMessaging messaging = FirebaseMessaging.instance ;
// // //
// // //
// // //   void requestNotificationPermission() async {
// // //     NotificationSettings settings = await messaging.requestPermission(
// // //         alert: true,
// // //         announcement: true,
// // //         badge: true,
// // //         carPlay: true,
// // //         criticalAlert: true,
// // //         provisional: true,
// // //         sound: true ,
// // //     );
// // //
// // //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// // //       if (kDebugMode) {
// // //         print('user granted permission');
// // //       }
// // //     } else if (settings.authorizationStatus ==
// // //         AuthorizationStatus.provisional) {
// // //       if (kDebugMode) {
// // //         print('user granted provisional permission');
// // //       }
// // //     } else {
// // //       //appsetting.AppSettings.openNotificationSettings();
// // //       if (kDebugMode) {
// // //         print('user denied permission');
// // //       }
// // //     }
// // //   }
// // //
// // //   // function to show visible notification when app is active
// // //   Future<void> showNotification(RemoteMessage message)async{
// // //
// // //     AndroidNotificationChannel channel = AndroidNotificationChannel(
// // //         message.notification!.android!.channelId.toString(),
// // //       message.notification!.android!.channelId.toString() ,
// // //       importance: Importance.max  ,
// // //       showBadge: true ,
// // //       playSound: true,
// // //       sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
// // //     );
// // //
// // //      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
// // //       channel.id.toString(),
// // //       channel.name.toString() ,
// // //       channelDescription: 'your channel description',
// // //       importance: Importance.high,
// // //       priority: Priority.high ,
// // //       playSound: true,
// // //       ticker: 'ticker' ,
// // //          sound: channel.sound
// // //     //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
// // //     //  icon: largeIconPath
// // //     );
// // //
// // //     const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
// // //       presentAlert: true ,
// // //       presentBadge: true ,
// // //       presentSound: true
// // //     ) ;
// // //
// // //     NotificationDetails notificationDetails = NotificationDetails(
// // //       android: androidNotificationDetails,
// // //       iOS: darwinNotificationDetails
// // //     );
// // //
// // //     Future.delayed(Duration.zero , (){
// // //       _flutterLocalNotificationsPlugin.show(
// // //           0,
// // //           message.notification!.title.toString(),
// // //           message.notification!.body.toString(),
// // //           notificationDetails ,
// // //       );
// // //     });
// // //
// // //   }
// // //
// // //   //function to get device token on which we will send the notifications
// // //   Future<String> getDeviceToken() async {
// // //     String? token = await messaging.getToken();
// // //     return token!;
// // //   }
// // //
// // //   void isTokenRefresh()async{
// // //     messaging.onTokenRefresh.listen((event) {
// // //       event.toString();
// // //       if (kDebugMode) {
// // //         print('refresh');
// // //       }
// // //     });
// // //   }
// // //
// // //   //handle tap on notification when app is in background or terminated
// // //   Future<void> setupInteractMessage(BuildContext context)async{
// // //
// // //     // when app is terminated
// // //     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
// // //
// // //     if(initialMessage != null){
// // //       handleMessage(context, initialMessage);
// // //     }
// // //
// // //
// // //     //when app ins background
// // //     FirebaseMessaging.onMessageOpenedApp.listen((event) {
// // //       handleMessage(context, event);
// // //     });
// // //
// // //   }
// // //
// // //   void handleMessage(BuildContext context, RemoteMessage message) {
// // //
// // //     if(message.data['type'] =='msj'){
// // //       Navigator.push(context,
// // //           MaterialPageRoute(builder: (context) => MessageScreen(
// // //             id: message.data['id'] ,
// // //           )));
// // //     }
// // //   }
// // //
// // //
// // //   Future forgroundMessage() async {
// // //     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
// // //       alert: true,
// // //       badge: true,
// // //       sound: true,
// // //     );
// // //   }
// // //
// // //
// // // }
// //
// // import 'dart:async';
// // import 'dart:convert';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // class NotificationManager {
// //   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   // static Future<void> init() async {
// //   //   final notificationManager = NotificationManager();
// //   //   await notificationManager.initialize();
// //   // }
// //
// //   static String darwinNotificationCategoryText = 'textCategory';
// //
// //    Future<void> initialize() async {
// //     final AndroidInitializationSettings initializationSettingsAndroid =
// //     AndroidInitializationSettings('@mipmap/ic_launcher');
// //     var initializationSettingsIOS = const DarwinInitializationSettings();
// //
// //     final InitializationSettings initializationSettings = InitializationSettings(
// //       android: initializationSettingsAndroid,
// //         iOS: initializationSettingsIOS,
// //     );
// //     await flutterLocalNotificationsPlugin.initialize(
// //       initializationSettings,
// //       onDidReceiveNotificationResponse:
// //           (NotificationResponse notificationResponse) {
// //         switch (notificationResponse.notificationResponseType) {
// //           case NotificationResponseType.selectedNotification:
// //             selectNotificationStream.add(notificationResponse.payload);
// //             break;
// //           case NotificationResponseType.selectedNotificationAction:
// //             if (notificationResponse.actionId == navigationActionId) {
// //               selectNotificationStream.add(notificationResponse.payload);
// //             }
// //             break;
// //         }
// //       },
// //       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
// //     );
// //   }
// //
// //   String navigationActionId = 'id_3';
// //   final StreamController<String?> selectNotificationStream =
// //   StreamController<String?>.broadcast();
// //
// //   @pragma('vm:entry-point')
// //   void notificationTapBackground(NotificationResponse notificationResponse) {
// //     // ignore: avoid_print
// //     print('notification(${notificationResponse.id}) action tapped: '
// //         '${notificationResponse.actionId} with'
// //         ' payload: ${notificationResponse.payload}');
// //     if (notificationResponse.input?.isNotEmpty ?? false) {
// //       // ignore: avoid_print
// //       print(
// //           'notification action tapped with input: ${notificationResponse.input}');
// //     }
// //   }
// //
// //   Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
// //     var payloadData = jsonDecode(notificationResponse.payload!);
// //     print("payload $payloadData"); // Corrected variable name
// //     if (payloadData["type"] == "something" && payloadData["id"] != "something") {
// //
// //     }
// //   }
// //
// //   static Future<void> showNotification(String payload, String title, String details) async {
// //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //         AndroidNotificationDetails('0', 'moneyCus',
// //             importance: Importance.max,
// //             priority: Priority.high,
// //             ticker: 'ticker');
// //     const NotificationDetails platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);
// //     await flutterLocalNotificationsPlugin.show(
// //       0,
// //       title,
// //       details,
// //       platformChannelSpecifics,
// //       payload: payload,
// //     );
// //   }
// //
// //
// // }
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:xanh_coffee/router/router_app.dart';
// import 'package:xanh_coffee/router/router_string.dart';
// import 'package:xanh_coffee/screens/driver/history_order/history_order_screen.dart';
// import 'package:xanh_coffee/screens/driver/order/order_screen.dart';
// import 'package:xanh_coffee/screens/driver/order_time_screen/order_time_screen.dart';
// import 'package:xanh_coffee/screens/map/map_screen.dart';
// import 'package:xanh_coffee/screens/order_detail/order_detail_screen.dart';
// import 'package:xanh_coffee/services/services.dart';
// import 'package:path/path.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
//
// import '../helper/socket_connect/socket_io_admin.dart';
// import '../helper/socket_connect/socket_io_driver.dart';
// import '../share/share_widget.dart';
//
// int id = 0;
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// /// Streams are created so that app can respond to notification-related events
// /// since the plugin is initialised in the `main` function
// final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
//
// final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
//
// const String portName = 'notification_send_port';
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;
//
// /// A notification action which triggers a url launch event
// const String urlLaunchActionId = 'id_1';
//
// /// A notification action which triggers a App navigation event
// const String navigationActionId = 'id_3';
//
// /// Defines a iOS/MacOS notification category for text input actions.
// const String darwinNotificationCategoryText = 'textCategory';
//
// /// Defines a iOS/MacOS notification category for plain actions.
// const String darwinNotificationCategoryPlain = 'plainCategory';
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // ignore: avoid_print
//   print('notification(${notificationResponse.id}) action tapped: '
//       '${notificationResponse.actionId} with'
//       ' payload: ${notificationResponse.payload}');
//   if (notificationResponse.input?.isNotEmpty ?? false) {
//     // ignore: avoid_print
//     print('notification action tapped with input: ${notificationResponse.input}');
//   }
// }
//
// @pragma('vm:entry-point')
// void handleNotificationClick(String? payload) {
//   if (payload != null) {
//     // final data = jsonDecode(payload);
//     // if (data['type'] == 'message') {
//     print("object----------------------");
//     // }
//   }
// }
//
// // class NotificationManager {
// //   static final NotificationManager instance = NotificationManager._internal();
// //
// //   factory NotificationManager() {
// //     return instance;
// //   }
// //
// //   NotificationManager._internal();
// //
// //   Future<Map<String, bool>> init() async {
// //     // Kiểm tra quyền thông báo trên Android/iOS
// //     final permissionStatus = await Permission.notification.status;
// //
// //     if (permissionStatus.isGranted) {
// //       // Nếu quyền đã được cấp
// //       return {'success': true};
// //     } else {
// //       // Nếu quyền chưa được cấp, yêu cầu quyền
// //       final permissionRequestStatus = await Permission.notification.request();
// //
// //       if (permissionRequestStatus.isGranted) {
// //         // Nếu quyền được cấp sau khi yêu cầu
// //         return {'success': true};
// //       } else {
// //         // Nếu quyền bị từ chối, yêu cầu người dùng vào cài đặt để cấp quyền
// //         if (Platform.isAndroid) {
// //           await openAppSettings();
// //         }
// //
// //         return {'success': false, 'open_setting': true};
// //       }
// //     }
// //   }
// //
// //   Future<void> _configureLocalTimeZone() async {
// //     if (kIsWeb || Platform.isLinux) {
// //       return;
// //     }
// //     tz.initializeTimeZones();
// //     final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
// //     tz.setLocalLocation(tz.getLocation(timeZoneName!));
// //   }
// //
// //   Future<void> main() async {
// //     // needed if you intend to initialize in the `main` function
// //     WidgetsFlutterBinding.ensureInitialized();
// //
// //     await _configureLocalTimeZone();
// //
// //     final NotificationAppLaunchDetails? notificationAppLaunchDetails =
// //         !kIsWeb && Platform.isLinux ? null : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
// //     // String initialRoute = HomePage.routeName;
// //     if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
// //       selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
// //       // initialRoute = SecondPage.routeName;
// //     }
// //     final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //     final List<DarwinNotificationCategory> darwinNotificationCategories = <DarwinNotificationCategory>[
// //       DarwinNotificationCategory(
// //         darwinNotificationCategoryText,
// //         actions: <DarwinNotificationAction>[
// //           DarwinNotificationAction.text(
// //             'text_1',
// //             'Action 1',
// //             buttonTitle: 'Send',
// //             placeholder: 'Placeholder',
// //           ),
// //         ],
// //       ),
// //       DarwinNotificationCategory(
// //         darwinNotificationCategoryPlain,
// //         actions: <DarwinNotificationAction>[
// //           DarwinNotificationAction.plain('id_1', 'Action 1'),
// //           DarwinNotificationAction.plain(
// //             'id_2',
// //             'Action 2 (destructive)',
// //             options: <DarwinNotificationActionOption>{
// //               DarwinNotificationActionOption.destructive,
// //             },
// //           ),
// //           DarwinNotificationAction.plain(
// //             navigationActionId,
// //             'Action 3 (foreground)',
// //             options: <DarwinNotificationActionOption>{
// //               DarwinNotificationActionOption.foreground,
// //             },
// //           ),
// //           DarwinNotificationAction.plain(
// //             'id_4',
// //             'Action 4 (auth required)',
// //             options: <DarwinNotificationActionOption>{
// //               DarwinNotificationActionOption.authenticationRequired,
// //             },
// //           ),
// //         ],
// //         options: <DarwinNotificationCategoryOption>{
// //           DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
// //         },
// //       )
// //     ];
// //
// //     /// Note: permissions aren't requested here just to demonstrate that can be
// //     /// done later
// //     final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
// //       requestAlertPermission: false,
// //       requestBadgePermission: false,
// //       requestSoundPermission: false,
// //       onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
// //         didReceiveLocalNotificationStream.add(
// //           ReceivedNotification(
// //             id: id,
// //             title: title,
// //             body: body,
// //             payload: payload,
// //           ),
// //         );
// //       },
// //       notificationCategories: darwinNotificationCategories,
// //     );
// //     final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
// //       defaultActionName: 'Open notification',
// //       defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
// //     );
// //     final InitializationSettings initializationSettings = InitializationSettings(
// //       android: initializationSettingsAndroid,
// //       iOS: initializationSettingsDarwin,
// //       macOS: initializationSettingsDarwin,
// //       linux: initializationSettingsLinux,
// //     );
// //     await flutterLocalNotificationsPlugin.initialize(
// //       initializationSettings,
// //       onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
// //         switch (notificationResponse.notificationResponseType) {
// //           case NotificationResponseType.selectedNotification:
// //             selectNotificationStream.add(notificationResponse.payload);
// //             break;
// //           case NotificationResponseType.selectedNotificationAction:
// //             if (notificationResponse.actionId == navigationActionId) {
// //               selectNotificationStream.add(notificationResponse.payload);
// //             }
// //             break;
// //         }
// //       },
// //       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
// //     );
// //     // await flutterLocalNotificationsPlugin.initialize(
// //     //   initializationSettings,
// //     //   onDidReceiveNotificationResponse: (NotificationResponse response) {
// //     //     print("Notification Response: ${response.payload}");
// //     //     if (response.payload != null) {
// //     //       try {
// //     //         final Map<String, dynamic> decodedPayload = jsonDecode(response.payload!);
// //     //         print("Payload đã giải mã: $decodedPayload");
// //     //         print(decodedPayload['driver']);
// //     //         if (decodedPayload['driver'] == true && decodedPayload['driver'] != null) {
// //     //           print(decodedPayload['normal']);
// //     //           if (decodedPayload['normal'] == true) {
// //     //             navigatorKey.currentState?.pushAndRemoveUntil(
// //     //               MaterialPageRoute(builder: (context) => OrderRunningScreen(order: decodedPayload['order_id'])),
// //     //               (route) => route.isFirst,
// //     //             );
// //     //           } else {
// //     //             navigatorKey.currentState?.pushAndRemoveUntil(
// //     //               MaterialPageRoute(builder: (context) => OrderTimeScreen(order: decodedPayload['order_id'])),
// //     //               (route) => route.isFirst,
// //     //             );
// //     //           }
// //     //         } else {
// //     //           navigatorKey.currentState?.pushAndRemoveUntil(
// //     //             MaterialPageRoute(
// //     //                 builder: (context) => OrderDetailScreen(
// //     //                       id: decodedPayload['order_id'].toString(),
// //     //                       normal: decodedPayload['normal'],
// //     //                       time: decodedPayload['time'].toString(),
// //     //                     )),
// //     //             (route) => route.isFirst,
// //     //           );
// //     //         }
// //     //       } catch (e) {
// //     //         print("Lỗi khi xử lý payload: $e");
// //     //       }
// //     //     } else {
// //     //       print("Payload null");
// //     //     }
// //     //   },
// //     // );
// //
// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
// //       if (response.payload != null) {
// //         handleNotificationNavigation(response.payload!);
// //       }
// //     });
// //   }
// //
// //   void handleNotificationNavigation(String? payload) {
// //     try {
// //       if (payload != null) {
// //         try {
// //           final Map<String, dynamic> decodedPayload = jsonDecode(payload!);
// //           print("Payload đã giải mã: $decodedPayload");
// //           print(decodedPayload['driver']);
// //           if (decodedPayload['driver'] == true && decodedPayload['driver'] != null) {
// //             print(decodedPayload['normal']);
// //             if (decodedPayload['normal'] == true) {
// //               navigatorKey.currentState?.pushAndRemoveUntil(
// //                 MaterialPageRoute(builder: (context) => OrderRunningScreen(order: decodedPayload['order_id'])),
// //                 (route) => route.isFirst,
// //               );
// //             } else {
// //               navigatorKey.currentState?.pushAndRemoveUntil(
// //                 MaterialPageRoute(builder: (context) => OrderTimeScreen(order: decodedPayload['order_id'])),
// //                 (route) => route.isFirst,
// //               );
// //             }
// //           } else {
// //             navigatorKey.currentState?.pushAndRemoveUntil(
// //               MaterialPageRoute(
// //                   builder: (context) => OrderDetailScreen(
// //                         id: decodedPayload['order_id'].toString(),
// //                         normal: decodedPayload['normal'],
// //                         time: decodedPayload['time'].toString(),
// //                       )),
// //               (route) => route.isFirst,
// //             );
// //           }
// //         } catch (e) {
// //           print("Lỗi khi xử lý payload: $e");
// //         }
// //       } else {
// //         print("Payload null");
// //       }
// //     } catch (e) {
// //       print("Lỗi khi xử lý payload: $e");
// //     }
// //   }
// //
// //   static Future<void> showNotification(Map<String, dynamic> payload, String title, String details) async {
// //     final String jsonPayload = jsonEncode(payload);
// //     const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('id:1', 'Admin',
// //         channelDescription: 'Thông báo Admin', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
// //     const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
// //     await flutterLocalNotificationsPlugin.show(id++, "HKN-$title", details, notificationDetails, payload: jsonPayload);
// //   }
// //
// // // static Future<void> showNotificationPayload(String payload, String title, String details) async {
// // //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
// // //   AndroidNotificationDetails('0', 'moneyCus',
// // //       importance: Importance.max,
// // //       priority: Priority.high,
// // //       ticker: 'ticker');
// // //   const NotificationDetails platformChannelSpecifics =
// // //   NotificationDetails(android: androidPlatformChannelSpecifics);
// // //   await flutterLocalNotificationsPlugin.show(
// // //     0,
// // //     title,
// // //     details,
// // //     platformChannelSpecifics,
// // //     payload: payload,
// // //   );
// // // }
// // }
//
// class NotificationServicesFireBase {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//
//     var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
//       handleMessage(context, message);
//     });
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//
//       KSPrint.log("notifications title:${notification!.title}");
//       KSPrint.log("notifications body:${notification.body}");
//       if (message.data.isNotEmpty) {
//         KSPrint.log("Data: ${message.data}");
//       } else {
//         KSPrint.log("Data is empty!");
//       }
//
//       if (Platform.isIOS) {
//         forgroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//     KSPrint.log('Đã tạo tạo nhanh thông báo');
//   }
//
//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }
//
//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//       playSound: true,
//       // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
//     );
//
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channel.id.toString(), channel.name.toString(),
//         channelDescription: 'FCM', importance: Importance.high, priority: Priority.high, playSound: true, ticker: 'ticker', sound: channel.sound
//         //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//         //  icon: largeIconPath
//         );
//
//     const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
//
//     NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
//
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }
//
//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = "";
//     if (Platform.isAndroid) {
//       token = await messaging.getToken();
//     } else if (Platform.isIOS) {
//       final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//       print('APNs Token: $apnsToken');
//       if (apnsToken != null) {
//         // APNS token is available, make FCM plugin API requests...
//
//         // Get the FCM token
//         // token = await messaging.getToken();
//         try {
//           final firebase = FirebaseMessaging.instance;
//           String? fcmToken = await firebase.getToken();
//           print('FCM Token: $fcmToken');
//           token = fcmToken;
//         } catch (e, stackTrace) {
//           print('Error fetching FCM token: $e\n$stackTrace');
//         }
//         // Now you have both APNS token and FCM token, you can send them to your server
//         // for server-side processing or store them locally if needed.
//
//         // Example: Send tokens to your server
//         // sendTokensToServer(apnsToken, fcmToken);
//       }else{
//         token = apnsToken;
//       }
//       // token = await messaging.getToken();
//     }
//     // await Future.delayed(Duration(seconds: 2));
//     return (token == null) ? "" : token;
//   }
//
//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }
//
//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     KSPrint.log('Đã tạo điều kiện thng báo');
//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }
//
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     Map<String, dynamic> messageData = message.data;
//     switch (messageData['code_message']) {
//       /// Admin điều phối đơn thường -- tbtx
//       case "admin_selected_driver_for_regular_order":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': true,
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Admin điều phối đơn dự án -- tbtx
//       case "assign_driver_for_project_order":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': true,
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Admin điều phối thêm chuyến -- tbtx
//       case "add_turn_for_project_order":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': true,
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo cho tài xế đơn dự án sắp bắt đầu -- tbtx
//       case "project_order_start_time_approaching":
//         break;
//
//       /// Tài xế xác nhận lấy hàng -- tbad
//       case "driver_confirmed_got_regular_order":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Tài xế xác nhận giao hàng  -- tbad
//       case "driver_confirmed_order_was_delivered":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo tới admin đơn sắp 80%  -- tbad
//       case "project_order_expected_80%":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo tới admin đơn 80%  -- tbad
//       case "project_order_reach_80%":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo tới admin đơn 100%  -- tbad
//       case "project_order_reach_100%":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo tới admin đơn sự cố  -- tbad
//       case "log_project_order_problem":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//
//       /// Thông báo tới admin đơn dự án sự cố  -- tbad
//       case "driver_report_order_problem_to_admin":
//         bool normal = messageData['order_type'] == "2" ? false : true;
//
//         Map<String, dynamic> dataSend = {
//           'order_id': messageData['order_id'],
//           'normal': normal,
//           'driver': false,
//           'time': messageData['time_order_created'],
//         };
//         handleNotificationNavigation(dataSend);
//         break;
//       default:
//         break;
//     }
//   }
//
//   void handleNotificationNavigation(final Map<String, dynamic>? payload) {
//     if (payload == null) {
//       log("Payload null");
//       return;
//     }
//
//     if(Platform.isAndroid){
//       if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused || WidgetsBinding.instance.lifecycleState == AppLifecycleState.inactive) {
//         _navigateToTargetScreen(payload);
//
//       }
//
//       else {
//         navigatorKey.currentState?.pushNamedAndRemoveUntil(ScreenName.root, arguments:{
//           'payload': payload,
//         },(route) => false);
//
//       }
//     }else{
//       if (HKNSocketAdmin.instance.isSocketConnected()  || HKNSocketDriver.instance.isSocketConnected() ) {
//
//         _navigateToTargetScreen(payload);
//
//       }
//
//       else {
//
//
//         navigatorKey.currentState?.pushNamedAndRemoveUntil(ScreenName.root, arguments:{
//           'payload': payload,
//         },(route) => false);
//       }
//     }
//
//
//
//   }
//
//   Future<void> _navigateToTargetScreen(final Map<String, dynamic>? payload) async {
//     try {
//       if (payload != null) {
//         try {
//           showCustomLoading();
//           await Future.delayed(Duration(milliseconds: 2000));
//           final Map<String, dynamic> decodedPayload = (payload);
//           log("Payload đã giải mã: $decodedPayload");
//
//           if (decodedPayload['driver'] == true) {
//             if (decodedPayload['normal'] == true) {
//               navigatorKey.currentState?.pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => OrderRunningScreen(order: int.parse(decodedPayload['order_id']))),
//                 (route) => route.isFirst,
//               );
//             } else {
//               navigatorKey.currentState?.pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => OrderTimeScreen(order: int.parse(decodedPayload['order_id']))),
//                 (route) => route.isFirst,
//               );
//             }
//           } else {
//             navigatorKey.currentState?.pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (context) => OrderDetailScreen(
//                         id: decodedPayload['order_id'],
//                         normal: decodedPayload['normal'],
//                         time: decodedPayload['time'].toString(),
//                       )),
//               (route) => route.isFirst,
//             );
//           }
//           closeCustomLoading();
//         } catch (e) {
//           print("Lỗi khi xử lý payload trong: $e");
//         }
//       } else {
//         print("Payload null");
//       }
//     } catch (e) {
//       print("Lỗi khi xử lý payload: $e");
//     }
//   }
//
//   Future forgroundMessage() async {
//     KSPrint.log('Đã tạo điều kiện kết nối thông báo');
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }

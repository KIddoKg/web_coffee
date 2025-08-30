// import 'dart:developer' as dev;
// import 'dart:developer';
//
//
// import 'package:xanh_coffee/config/env.dart';
//
// enum AppLogEventStatus { waiting, fail, error, success, started }
//
// class AppLogEvent {
//   String name;
//   String descriptionAction;
//   dynamic matchResult;
//   dynamic actualResult;
//
//   AppLogEventStatus status;
//
//   late DateTime createdTime;
//
//   AppLogEvent({
//     required this.name,
//     required this.descriptionAction,
//     this.matchResult,
//     this.actualResult,
//     this.status = AppLogEventStatus.started,
//   }) {
//     createdTime = DateTime.now();
//   }
// }
//
// class CommonLog {
//   final String message;
//   final LogType type;
//   final String time;
//
//   CommonLog({
//     required this.message,
//     required this.type,
//     required this.time,
//   });
// }
//
// class AppLog {
//   static final List<CommonLog> _listLog = <CommonLog>[].obs;
//
//   static List<CommonLog> get listLog => _listLog;
//   static bool needShowLog = false;
//
//   /// Log the detailed error in the console with red color.
//   /// Log error to Firebase Crashlytics.
//   static void error(String message, [Object? error, StackTrace? trace]) {
//     if (needShowLog) {
//       log('\x1B[31m$message\x1B[0m');
//       if (error != null) log('\x1B[31m$error\x1B[0m');
//       if (trace != null) log('\x1B[33m$trace\x1B[0m');
//       _listLog.insert(
//         0,
//         CommonLog(
//           message: message,
//           type: LogType.ERROR,
//           time: DateTime.now().isUtc.toString(),
//         ),
//       );
//     }
//
//     // FirebaseCrashlytics.instance.recordError(error, trace, printDetails: true);
//   }
//
//   /// Log the detailed warning in the console with yellow color.
//   static void warning(String message, [Object? obj, StackTrace? trace]) {
//     if (needShowLog) {
//       log('\x1B[33m$message\x1B[0m');
//       if (obj != null) log('\x1B[33m$obj\x1B[0m');
//       if (trace != null) log('\x1B[33m$trace\x1B[0m');
//       _listLog.insert(
//         0,
//         CommonLog(
//           message: message,
//           type: LogType.WARNING,
//           time: DateTime.now().isUtc.toString(),
//         ),
//       );
//     }
//   }
//
//   /// Log the detailed info in the console with Green color.
//   static void info(String message, [Object? obj, StackTrace? trace]) {
//     if (needShowLog) {
//       log('\x1B[32m$message\x1B[0m');
//       if (obj != null) log('\x1B[32m$obj\x1B[0m');
//       if (trace != null) log('\x1B[33m$trace\x1B[0m');
//       _listLog.insert(
//         0,
//         CommonLog(
//           message: message,
//           type: LogType.INFO,
//           time: DateTime.now().isUtc.toString(),
//         ),
//       );
//     }
//   }
//
//   static void clearLog() {
//     _listLog.clear();
//   }
// }
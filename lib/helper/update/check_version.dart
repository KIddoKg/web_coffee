// import 'dart:async';
// import 'dart:io';
//
// // import 'package:flutter_app_installer/flutter_app_installer.dart';
// import 'package:dio/dio.dart';
//
// import 'package:flutter/foundation.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../models/auth/driver_save_model.dart';
// import '../../router/router_app.dart';
// import '../../router/router_string.dart';
// import '../../services/services.dart';
// import '../appsetting.dart';
//
// import 'update_screen.dart'; // Import màn hình cập nhật
// import 'package:app_installer/app_installer.dart';
//
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class UpdateChecker {
//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("app_update");
//
//   // final FlutterAppInstaller flutterAppInstaller = FlutterAppInstaller();
//   Future<void> listenForUpdates(BuildContext context) async {
//     _databaseRef.onValue.listen((event) async {
//       final data = event.snapshot.value;
//       if (data is Map) {
//         Map<String, dynamic> updateData = Map<String, dynamic>.from(data);
//         PackageInfo packageInfo = await PackageInfo.fromPlatform();
//         String currentVersion = packageInfo.version;
//         if (_isNewVersion(currentVersion, updateData['latest_version'])) {
//           // await checkLogout(context, updateData);
//            _handleUpdate(context, updateData);
//
//         }
//       }
//     });
//   }
//
//   Future<String?> checkVersion() async {
//     try {
//       DatabaseEvent event = await _databaseRef.once();
//
//       final data = event.snapshot.value;
//
//       if (data is Map) {
//         return data["latest_version"] as String?;
//       }
//       return null;
//     } catch (e) {
//       print("❌ Lỗi lấy phiên bản mới nhất: $e");
//       return null;
//     }
//   }
//
//   Future<bool> shouldUpdate() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String currentVersion = packageInfo.version;
//     String? latestVersion = await checkVersion();
//
//     if (latestVersion == null) {
//       return false;
//     }
//     return _isNewVersion(currentVersion, latestVersion);
//   }
//
//   Future<void> checkLogout(BuildContext context, Map<String, dynamic> updateData) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String currentVersion = packageInfo.version;
//
//     String latestVersion = updateData['latest_version'];
//
//     bool forceUpdate = updateData['force_update'];
//
//     if (_isNewVersion(currentVersion, latestVersion)) {
//       logOut(context);
//     }
//   }
//
//   void logOut(BuildContext context) async {
//     bool isExits = AppSetting.pref.containsKey('@appSetting');
//     if (isExits == true) {
//
//       HKNSocketAdmin.instance.disconnectWebSocket();
//       HKNSocketDriver.instance.disconnectWebSocket();
//       var res = await Services.instance.setContext(context).FCMToken(DriverSaveModel.instance.id ?? AdminSaveModel.instance.id ?? 0,DriverSaveModel.instance.role ?? AdminSaveModel.instance.role ?? "", "token");
//       if (res == true) {
//         AppSetting.instance.reset();
//         await AppSetting.pref.remove('@appSetting');
//         await AppSetting.pref.remove('@profile');
//
//         AppSetting.instance.accessToken = "";
//
//         if (!context.mounted) return;
//
//         Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//       } else {
//         Fluttertoast.showToast(msg: 'Có lỗi xảy ra khi đăng xuất. Bạn vẫn đăng xuất bình thường.');
//         AppSetting.instance.reset();
//         await AppSetting.pref.remove('@appSetting');
//         await AppSetting.pref.remove('@profile');
//         AppSetting.instance.accessToken = "";
//
//         if (!context.mounted) return;
//
//         Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//       }
//     }
//   }
//
//   void _handleUpdate(BuildContext context, Map<String, dynamic> updateData) async {
//     showAlertIOS(context, "Thông báo", "Có phiên bản test mới ${updateData['latest_version']}", onTap: () async{
//       logOut(context);
//     });
//   }
//
//   bool _isNewVersion(String currentVersion, String latestVersion) {
//     List<int> currVer = currentVersion.split('.').map(int.parse).toList();
//     List<int> newVer = latestVersion.split('.').map(int.parse).toList();
//
//     for (int i = 0; i < newVer.length; i++) {
//       if (i >= currVer.length || newVer[i] > currVer[i]) {
//         return true;
//       } else if (newVer[i] < currVer[i]) {
//         return false;
//       }
//     }
//     return false;
//   }
//
//   final AppInstaller appInstaller = AppInstaller();
//
//   Future<bool> downloadFile(Function(double) onProgress) async {
//     DatabaseEvent event = await _databaseRef.once();
//     final data = event.snapshot.value;
//     Dio dio = Dio();
//     String fileUrl = "";
//     String version = "";
//
//     if (data is Map) {
//       version = data["latest_version"] as String;
//       fileUrl = data["download_url"] as String;
//     }
//
//     Directory? dir = await getExternalStorageDirectory();
//     if (dir == null) {
//       if (kDebugMode) {
//         print("❌ Lỗi: Không tìm thấy thư mục lưu trữ.");
//       }
//       return false;
//     }
//
//     String finalFilePath = "${dir.path}/$version.apk";
//
//     // 🔥 Kiểm tra nếu file đã tồn tại -> Cài đặt luôn
//     File existingFile = File(finalFilePath);
//     if (await existingFile.exists()) {
//       if (kDebugMode) {
//         print("📂 File đã tồn tại: $finalFilePath");
//       }
//       if (kDebugMode) {
//         print("📲 Tiến hành cài đặt APK...");
//       }
//       try {
//         await AppInstaller.installApk(finalFilePath);
//         return true;
//       } catch (e) {
//         if (kDebugMode) {
//           print("❌ Lỗi cài đặt APK: $e");
//         }
//         return false;
//       }
//     }
//
//     // 🔥 Nếu file chưa tồn tại, tiến hành tải xuống
//     String tempFilePath = "${dir.path}/$version.apkp";
//
//     try {
//       print("📥 Đang tải file về: $tempFilePath");
//
//       await dio.download(
//         fileUrl,
//         tempFilePath,
//         options: Options(receiveTimeout: Duration(minutes: 5)),
//         onReceiveProgress: (received, total) {
//           if (total > 0) {
//             double progress = received / total;
//             onProgress(progress);
//             print("📊 Tiến trình tải: ${(progress * 100).toStringAsFixed(2)}%");
//           }
//         },
//       );
//
//       File file = File(tempFilePath);
//       if (await file.exists()) {
//         await file.rename(finalFilePath);
//         print("✅ File tải xong: $finalFilePath");
//
//         try {
//           await AppInstaller.installApk(finalFilePath);
//           print("📲 Cài đặt APK...");
//           return true;
//         } catch (e) {
//           print("❌ Lỗi cài đặt APK: $e");
//           return false;
//         }
//       } else {
//         print("❌ File tải về không tồn tại!");
//         return false;
//       }
//     } catch (e) {
//       print("❌ Lỗi tải file: $e");
//       return false;
//     }
//   }
//
//
//   Future<bool> checkUpdateFirst(Function(double) onProgress) async {
//     bool check = await UpdateChecker().shouldUpdate();
//     if (check) {
//       bool success = await UpdateChecker().downloadFile((progress) {
//         onProgress(progress);
//       });
//       return success;
//     } else {
//       return false;
//     }
//   }
//
// // void _showUpdateDialog(BuildContext context, String url, bool forceUpdate) {
// //   showDialog(
// //     context: context,
// //     barrierDismissible: !forceUpdate,
// //     builder: (context) {
// //       return AlertDialog(
// //         title: Text("Cập nhật ứng dụng"),
// //         content: Text("Phiên bản mới đã có, bạn có muốn cập nhật không?"),
// //         actions: [
// //           if (!forceUpdate)
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text("Để sau"),
// //             ),
// //           TextButton(
// //             onPressed: () async {
// //               Uri uri = Uri.parse(url);
// //               if (await canLaunchUrl(uri)) {
// //                 await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
// //               } else {
// //                 print("Không thể mở URL: $url");
// //               }
// //             },
// //             child: Text("Cập nhật ngay"),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
//
// // void _showUpdateDialog(BuildContext context, String url, bool forceUpdate) {
// //   showDialog(
// //     context: context,
// //     barrierDismissible: !forceUpdate,
// //     builder: (context) {
// //       return AlertDialog(
// //         title: Text("Cập nhật ứng dụng"),
// //         content: Text("Phiên bản mới đã có, bạn có muốn cập nhật không?"),
// //         actions: [
// //           if (!forceUpdate)
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text("Để sau"),
// //             ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => UpdateScreen(downloadUrl: url),
// //                 ),
// //               );
// //             },
// //             child: Text("Cập nhật ngay"),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
// }

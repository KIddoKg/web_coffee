// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:xanh_coffee/helper/appsetting.dart';
// import 'package:xanh_coffee/share/share_widget.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:bot_toast/bot_toast.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../generated/assets.gen.dart';
// import '../../models/auth/admin_save_model.dart';
// import '../../services/notification_services.dart';
// import '../../services/services.dart';
// import '../show_message.dart';
//
//
// class PermissionNotificationService {
//   Future<bool> checkPermissionNotification(BuildContext context) async {
//     final status = await Permission.notification.status;
//
//     if (status.isGranted) {
//       return await _registerToken(context); // ✅ đã có quyền → xử lý luôn
//     }
//
//     if (status.isPermanentlyDenied) {
//       showAlertIOS(
//         context,
//         'Quyền truy cập bị từ chối',
//         'Bạn đã từ chối quyền và hệ thống không thể hỏi lại. Vui lòng vào Cài đặt để cấp lại quyền.',
//         onTap: () {
//           openAppSettings();
//         },
//       );
//       return false;
//     }
//
//     final completer = Completer<bool>();
//
//     showCustomDialog(
//       context: context,
//       imageAsset: Assets.img.bgPermissionNotification.keyName,
//       title: 'CHO PHÉP THÔNG BÁO TỪ ỨNG DỤNG',
//       titleOne: 'Tiếp tục',
//       // titleTwo: 'Bỏ qua',
//       isShowClose: false,
//       isShowOnlyActionButton: true,
//       detail: 'Điều này hỗ trợ ứng dụng gửi thông báo để bạn không bỏ lỡ về các cập nhật quan trọng.',
//       onContinue: () async {
//         Navigator.pop(context);
//
//         final result = await Permission.notification.request();
//
//         if (result.isGranted) {
//           final success = await _registerToken(context); // ✅ xử lý token
//           completer.complete(success);
//         } else {
//           completer.complete(false);
//         }
//       },
//       onHome: () {
//         Navigator.pop(context);
//         completer.complete(false);
//       },
//     );
//
//     return completer.future;
//   }
//
//   Future<bool> _registerToken(BuildContext context) async {
//     try {
//       final token = await NotificationServicesFireBase().getDeviceToken();
//       final res = await Services.instance
//           .setContext(context)
//           .FCMToken(AdminSaveModel.instance.id ?? 0, AdminSaveModel.instance.role ?? "", token);
//
//       if (res == true) {
//         AppSetting.instance.enableAuthenLocal = true;
//         AppSetting.instance.save();
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       KSPrint.log("Error getting token or sending to server: $e");
//       return false;
//     }
//   }
// }
//
//
//

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class UpdateScreen extends StatefulWidget {
//   final String downloadUrl;
//
//   const UpdateScreen({Key? key, required this.downloadUrl}) : super(key: key);
//
//   @override
//   _UpdateScreenState createState() => _UpdateScreenState();
// }
//
// class _UpdateScreenState extends State<UpdateScreen> {
//   double _progress = 0.0;
//   bool _isDownloading = false;
//   String _filePath = "";
//
//   Future<void> _downloadAndInstallApk() async {
//     setState(() {
//       _isDownloading = true;
//       _progress = 0.0;
//     });
//
//     // Yêu cầu quyền lưu trữ
//     if (await _requestPermission()) {
//       try {
//         Directory directory = await getApplicationDocumentsDirectory();
//         _filePath = "${directory.path}/update.apk";
//
//         Dio dio = Dio();
//         await dio.download(
//           widget.downloadUrl,
//           _filePath,
//           onReceiveProgress: (received, total) {
//             if (total != -1) {
//               setState(() {
//                 _progress = received / total;
//               });
//             }
//           },
//         );
//
//         setState(() {
//           _isDownloading = false;
//         });
//
//         // Mở file APK để cài đặt
//         OpenFilex.open(_filePath);
//       } catch (e) {
//         setState(() {
//           _isDownloading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi tải xuống: $e")),
//         );
//       }
//     }
//   }
//
//   Future<bool> _requestPermission() async {
//     if (Platform.isAndroid) {
//       var status = await Permission.storage.request();
//       return status.isGranted;
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cập nhật ứng dụng")),
//       body: Center(
//         child: _isDownloading
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(value: _progress),
//             SizedBox(height: 10),
//             Text("${(_progress * 100).toStringAsFixed(0)}%"),
//           ],
//         )
//             : ElevatedButton(
//           onPressed: _downloadAndInstallApk,
//           child: Text("Tải & Cài đặt"),
//         ),
//       ),
//     );
//   }
// }
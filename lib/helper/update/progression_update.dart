// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:external_path/external_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_installer/flutter_app_installer.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../../helper/appsetting.dart';
// import '../../share/share_widget.dart';
//
//
// class UpdateVersionModel {
//   String version;
//   String description;
//   String package;
//   UpdateVersionModel({
//     required this.version,
//     required this.description,
//     required this.package,
//   });
//
//   UpdateVersionModel copyWith({
//     String? version,
//     String? description,
//     String? package,
//   }) {
//     return UpdateVersionModel(
//       version: version ?? this.version,
//       description: description ?? this.description,
//       package: package ?? this.package,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};
//
//     result.addAll({'version': version});
//     result.addAll({'description': description});
//     result.addAll({'package': package});
//
//     return result;
//   }
//
//   factory UpdateVersionModel.fromMap(Map<String, dynamic> map) {
//     return UpdateVersionModel(
//       version: map['version'] ?? '',
//       description: map['description'] ?? '',
//       package: map['package'] ?? '',
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory UpdateVersionModel.fromJson(String source) =>
//       UpdateVersionModel.fromMap(json.decode(source));
//
//   @override
//   String toString() =>
//       'UpdateVersionModel(version: $version, description: $description, package: $package)';
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is UpdateVersionModel &&
//         other.version == version &&
//         other.description == description &&
//         other.package == package;
//   }
//
//   @override
//   int get hashCode =>
//       version.hashCode ^ description.hashCode ^ package.hashCode;
// }
//
// class StatusCheckVersion {
//   static const String initApp = 'Khởi tạo ứng dụng';
//
//   static const String checking = 'Kiểm tra phiên bản';
//   static const String newVersion = 'Có phiên bản mới';
//   static const String fileUpdateExits = 'Đã tải về phiên bản cập nhật';
//   static const String done = 'Hoàn tất';
//   static const String dowloading = 'Đang tải';
//   static const String copyFile = 'Đang xử lý tệp';
//   static const String installing = 'Đang cài đặt';
//   static const String prepairFinish = 'Tối ưu dụng lượng';
// }
//
// class ProgressionUpdateVersion extends StatefulWidget {
//   Future<UpdateVersionModel?> Function()? onCheckingVersion;
//
//   void Function()? onBeforeChecking;
//   void Function()? onAfterChecking;
//
//   ProgressionUpdateVersion({
//     Key? key,
//     this.onCheckingVersion,
//     this.onAfterChecking,
//   }) : super(key: key);
//
//   @override
//   State<ProgressionUpdateVersion> createState() =>
//       _ProgressionUpdateVersionState();
// }
//
// class _ProgressionUpdateVersionState extends State<ProgressionUpdateVersion> {
//   bool isCheckUpdate = false;
//   bool hasNewVersion = false;
//   double progressingDownload = 0;
//   final FlutterAppInstaller flutterAppInstaller = FlutterAppInstaller();
//   String status = '';
//
//   @override
//   void initState() {
//     super.initState();
//
//     log('progression.checkingupdate');
//     checkHasUpdate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           KSProgressbar(
//             duration: const Duration(milliseconds: 200),
//             backgroundColor: const Color.fromARGB(64, 0, 0, 0),
//             progress: progressingDownload,
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           Text(
//             status,
//             style: const TextStyle(fontSize: 13, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future checkHasUpdate() async {
//     await Future.delayed(Duration.zero);
//
//     isCheckUpdate = true;
//
//     var arguments =
//     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
//     if (arguments != null && arguments['isLogout']) {
//       isCheckUpdate = false;
//       log('navigation.login from logout');
//       return;
//     }
//
//     UpdateVersionModel? appUpdateInfo;
//
//     if (widget.onCheckingVersion != null) {
//       appUpdateInfo = await widget.onCheckingVersion!();
//     }
//
//     await createProgressionUpdate(
//         '${StatusCheckVersion.checking} v${AppSetting.instance.version}',
//         pauseDuration: const Duration(milliseconds: 2500));
//
//     if (appUpdateInfo != null) {
//       hasNewVersion = appUpdateInfo.version != AppSetting.instance.version;
//       // if (widget.onHasNewVerion != null) widget.onHasNewVerion!(hasNewVersion);
//     }
//
//     if (hasNewVersion) {
//       await createProgressionUpdate(
//           status = hasNewVersion
//               ? StatusCheckVersion.newVersion
//               : StatusCheckVersion.initApp,
//           pauseDuration: const Duration(milliseconds: 2500));
//
//       var downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
//           ExternalPath.DIRECTORY_DOWNLOADS);
//       var file = File('$downloadDir/app-release.apk');
//       var isExists = await file.exists();
//
//       if (!isExists) {
//         await createProgressionUpdate(StatusCheckVersion.dowloading,
//             beginAction: () async {
//               var download =
//                   'https://storage.googleapis.com/dmclmobileapp.appspot.com/app-release.apk';
//
//               await FileDownloader.downloadFile(
//                 url: download,
//                 onProgress: (fileName, progress) {
//                   status = 'Đang tải $progress%';
//                   progressingDownload = progress;
//                   setState(() {});
//                 },
//                 onDownloadError: (errorMessage) {
//                   log('download.error $errorMessage');
//                 },
//                 onDownloadCompleted: (path) {
//                   file = File(path);
//                 },
//               );
//             });
//       }
//
//       var fileInstall = await createProgressionUpdate(
//           StatusCheckVersion.copyFile, beginAction: () async {
//         var pathDirTemp = await getExternalCacheDirectories();
//         var fileInstall = await file.copy('${pathDirTemp![0].path}/update.apk');
//         return fileInstall;
//       });
//
//       var resultInstall = await createProgressionUpdate(
//           StatusCheckVersion.installing, beginAction: () async {
//         // var result = await AndroidPackageInstaller.installApk(
//         //     apkFilePath: fileInstall.path);
//         // log('appinstaller.result ${PackageInstallerStatus.byCode(result!)}');
//         // var resultState = PackageInstallerStatus.byCode(result) ==
//         //     PackageInstallerStatus.success;
//         // if (!resultState) {
//         //   Fluttertoast.showToast(msg: 'Ứng dụng chưa hoàn tất cập nhật.');
//         // }
//         // return resultState;
//
//         // await AndroidIntent(
//         //     action: 'action_view',
//         //     data: 'content://$path',
//         //     type: "application/vnd.android.package-archive",
//         //     flags: [Flag.FLAG_ACTIVITY_NEW_TASK]).launch();
//
//         var result =
//         await flutterAppInstaller.installApk(filePath: fileInstall.path);
//
//         return result;
//       }, pauseDuration: const Duration(milliseconds: 2200));
//
//       if (resultInstall) {
//         await createProgressionUpdate(StatusCheckVersion.prepairFinish,
//             beginAction: () async {
//               await fileInstall.delete();
//               await file.delete();
//             });
//       }
//
//       await createProgressionUpdate(StatusCheckVersion.done,
//           beginAction: () async {});
//     }
//     // var path = 'storage/emulated/0/Download/xapk.apk';
//
//     await createProgressionUpdate(StatusCheckVersion.initApp,
//         beginAction: () async {
//           // isCheckUpdate = false;
//         });
//
//     isCheckUpdate = false;
//     Future.delayed(const Duration(milliseconds: 1000));
//     setState(() {});
//
//     if (widget.onCheckingVersion != null) {
//       // widget.onCheckingVersion!(isCheckUpdate);
//     }
//
//     if (widget.onAfterChecking != null) widget.onAfterChecking!();
//
//     return isCheckUpdate;
//   }
//
//   ///
//   /// Tạo một thanh tiến trình hiển thị quá trình kiểm tra cập nhật
//   ///
//   /// `[name]` - tên tiến trình
//   ///
//   /// `[action]` - hàm xử lý
//   ///
//   /// `[pauseDuration]` - thời gian tạm ừng khi kết thúc
//   ///
//   Future createProgressionUpdate(String name,
//       {Duration pauseDuration = const Duration(milliseconds: 1500),
//         Function()? beginAction,
//         Function()? completeAction}) async {
//     progressingDownload = 0;
//     status = name;
//     setState(() {});
//
//     if (beginAction != null) beginAction();
//
//     await Future.delayed(pauseDuration);
//     progressingDownload = 100;
//     setState(() {});
//
//     if (completeAction != null) completeAction();
//
//     await Future.delayed(const Duration(milliseconds: 1000));
//   }
// }

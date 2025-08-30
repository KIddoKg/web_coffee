// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:xanh_coffee/share/share_widget.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:bot_toast/bot_toast.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../generated/assets.gen.dart';
// import '../show_message.dart';
//
//
// class ImagePickerService {
//   final List<String> images;
//   final int maxMedia;
//   final Function notifyListeners;
//
//   ImagePickerService({
//     required this.images,
//     required this.maxMedia,
//     required this.notifyListeners,
//   });
//
//   // Show the action sheet
//   void showActionSheet(BuildContext context) {
//     if (images.length < maxMedia) {
//       final action = CupertinoActionSheet(
//         actions: <Widget>[
//           CupertinoActionSheetAction(
//             child: KSText("Chụp ảnh"),
//             onPressed: () {
//               Navigator.pop(context);
//               _pickImage(context, ImageSource.camera);
//             },
//           ),
//           CupertinoActionSheetAction(
//             child: KSText("Chọn từ thư viện"),
//             onPressed: () {
//               Navigator.pop(context);
//               _pickImage(context, ImageSource.gallery);
//             },
//           )
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           child: KSText("Huỷ"),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       );
//       showCupertinoModalPopup(context: context, builder: (context) => action);
//     } else {
//       Message.showToastMessage(context, 'Chỉ đuợc chọn tối đa $maxMedia ảnh');
//     }
//   }
//
//   // Handle image picking logic
//   Future<void> _pickImage(BuildContext context, ImageSource source) async {
//     if (source == ImageSource.camera) {
//       await checkPermissionCamera(context);
//     } else {
//       openGallery(context);
//     }
//   }
//
//   // Check camera permission and ask for it if necessary
//   Future<void> checkPermissionCamera(BuildContext context) async {
//     final status = await Permission.camera.status;
//     KSPrint.log("$status");
//
//     if (status.isGranted) {
//       // Nếu đã được cấp quyền, mở camera luôn
//       openCamera(context);
//     } else if (status.isPermanentlyDenied) {
//       // Nếu bị từ chối vĩnh viễn, yêu cầu mở settings
//       KSshowAlertIOS(
//         context,
//         'Quyền truy cập bị từ chối',
//         'Bạn đã từ chối quyền camera và hệ thống không thể hỏi lại. Vui lòng vào Cài đặt để cấp lại quyền.',
//         onTap: () {
//           openAppSettings();
//         },
//       );
//     } else {
//       // Hiển thị giải thích rồi request lại
//       KSshowCustomDialog(
//         context: context,
//         imageAsset: Assets.img.bgPermissionPhoto.keyName,
//         title: 'KÍCH HOẠT TRUY CẬP CHỤP ẢNH VÀ HÌNH ẢNH',
//         titleOne: 'Tiếp tục',
//         // titleTwo: 'Bỏ qua',
//         isShowOnlyActionButton: true,
//         isShowClose: false,
//
//         detail: 'Điều này hỗ trợ việc đăng tải ảnh, cập nhật hồ sơ trong ứng dụng.',
//         onContinue: () async {
//
//           Navigator.pop(context);
//
//             openCamera(context);
//
//         },
//         // onHome: () {
//         //   Navigator.pop(context);
//         // },
//       );
//     }
//   }
//
//
//   // Open the camera and pick an image
//   Future<void> openCamera(BuildContext context) async {
//     bool shouldShow = await Permission.camera.shouldShowRequestRationale;
//
//     KSPrint.log("shouldShowRequestRationale: $shouldShow");
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         maxWidth: 1024,
//         maxHeight: 1024,
//         source: ImageSource.camera,
//         preferredCameraDevice: CameraDevice.rear,
//       );
//       if (pickedFile != null) {
//
//         BotToast.showLoading();
//         images.add(pickedFile.path);
//         BotToast.closeAllLoading();
//         notifyListeners();
//       }
//     } catch (e) {
//     }
//   }
//
//   // Open the gallery and pick multiple images
//   Future<void> openGallery(BuildContext context) async {
//
//
//
//     try {
//       final picker = ImagePicker();
//       final selectedPickedFiles = await picker.pickMultiImage(
//         maxWidth: 1024,
//         maxHeight: 1024,
//       );
//
//       if (selectedPickedFiles == null || selectedPickedFiles.isEmpty) return;
//
//       final totalImages = images.length + selectedPickedFiles.length;
//       if (totalImages > maxMedia) {
//         Message.showToastMessage(
//           context,
//           'Tổng số ảnh không được vượt quá $maxMedia. Bạn chỉ có thể chọn thêm ${maxMedia - images.length} ảnh.',
//         );
//         return;
//       }
//
//       BotToast.showLoading();
//       for (final file in selectedPickedFiles) {
//         final url = await compressImage(file.path);
//         images.add(url);
//       }
//       BotToast.closeAllLoading();
//       notifyListeners();
//     } catch (e) {
//
//     showAlertIOS(
//         context,
//         "Thông báo",
//         "Không thể chọn ảnh từ thư viện. Vui lòng thử lại.",
//         onTap: () {
//           // Handle error
//         },
//       );
//
//     }
//   }
//
//   // Compress an image before saving it to the list
//   Future<String> compressImage(String fileUrl) async {
//     final dir = await path_provider.getTemporaryDirectory();
//     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     final targetPath = dir.absolute.path + '/$fileName.jpg';
//     await FlutterImageCompress.compressAndGetFile(fileUrl, targetPath,
//         minHeight: 1024, minWidth: 1024);
//     return targetPath;
//   }
//
//   // Implement this method to check camera permissions
//   // Future<bool> checkCameraPermission() async {
//   //   // Add your platform-specific camera permission checking logic here.
//   //   return true; // Return whether permission is granted
//   // }
// }

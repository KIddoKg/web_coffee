// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:xanh_coffee/config/env.dart';
// import 'package:xanh_coffee/helper/appsetting.dart';
//
// import 'package:xanh_coffee/models/auth/admin_save_model.dart';
// import 'package:xanh_coffee/share/app_imports.dart';
//
// import 'package:notification_center/notification_center.dart';
//
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import 'package:web_socket_channel/io.dart';
//
// import '../di/di.dart';
//
// class HKNSocketAdmin {
//   static final HKNSocketAdmin _instance = HKNSocketAdmin._internal();
//   static String identity = di<Env>().socket;
//
//   static HKNSocketAdmin get instance => _instance;
//   WebSocketChannel? channel;
//   BuildContext? _context;
//   bool? observation = false;
//
//   ValueNotifier<bool> connectionStatus = ValueNotifier(false);
//   Map<String, dynamic> result = {};
//   String userId = "user_125";
//
//   HKNSocketAdmin._internal();
//
//   HKNSocketAdmin initSocket() {
//     HKNSocketAdmin.instance.disconnectWebSocket();
//
//     // channel = IOWebSocketChannel.connect('ws://103.167.89.112:8088/ws');
//     channel = IOWebSocketChannel.connect(identity);
//
//     log('WebSocket connected $identity Admin successfully!');
//     _instance.observation = true;
//     connectionStatus.value = true;
//
//     sendMessage(jsonEncode({'event': 'register', 'userId': userId}));
//
//     channel!.stream.listen(
//       (message) {
//
//         print('Received: $message');
//         Map<String, dynamic> jsonData = jsonDecode(message);
//         if (jsonData['Body'] == null) return;
//
//         handleWebSocketMessage(jsonData);
//       },
//       onDone: () {
//         // _instance.observation = false;
//         // _instance.countConnect = 0;
//         // connectionStatus.value = false;
//         // print('WebSocket Channel Disconnected');
//         // You can handle reconnection logic here if needed
//       },
//       onError: (error) {
//         print('WebSocket Error: $error');
//         _instance.observation = false;
//         connectionStatus.value = false;
//
//         // Handle any errors during the WebSocket connection
//       },
//     );
//
//     if (channel!.closeCode == null) {
//       log('WebSocket channel is still open.');
//       return _instance;
//     } else {
//       _instance.observation = false;
//       log('WebSocket channel is closed. Code: ${channel!.closeCode}, Reason: ${channel!.closeReason}');
//     }
//
//     return _instance;
//   }
//
//   bool isSocketConnected() {
//     return _instance.observation == true && channel != null;
//   }
//
//   void sendMessage(String message) {
//     if (_instance.observation == true && channel != null) {
//       channel!.sink.add(message);
//       log('Sent: $message');
//     } else {
//       log('Cannot send message, WebSocket is not connected.');
//     }
//   }
//
//   disconnectWebSocket() async {
//     if (channel != null) {
//       connectionStatus.value = false;
//       _instance.observation = false;
//       print(observation);
//       channel!.sink.close();
//       print('WebSocket Channel Disconnected');
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   Map<String, dynamic> handleWebSocketMessage(Map<String, dynamic> data) {
//     String decodedString = utf8.decode(base64.decode(data['Body']));
//     Map<String, dynamic> messageData = jsonDecode(decodedString);
//     try {
//       KSPrint.log("${AdminSaveModel.instance.id}");
//       KSPrint.log(messageData['admin_id']);
//       KSPrint.log(messageData['message']);
//       if (messageData['admin_id'] == AdminSaveModel.instance.id) {
//         switch (messageData['message']) {
//           case "driver_confirmed_got_regular_order":
//             bool normal = messageData['order_type'] == 2 ? false : true;
//
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//             // String order = messageData['order_type_name'] == 1 ? "đơn thường" : "đơn dự án";
//             NotificationCenter().notify('reloadOrderDetail', data: true);
//             // NotificationManager.showNotification(
//             //     dataSend,
//             //     "Tài xế ${messageData['driver_name']} đã lấy hàng đơn ${messageData['order_code']} và đang vận chuyển.",
//             //     "Tài xế ${messageData['driver_name']} - ${messageData['vehicle_plate']} đã lấy hàng thành công cho đơn mã ${messageData['order_code']} và đang trong quá trình vận chuyển. Vui lòng theo dõi hành trình trong ứng dụng.");
//             break;
//           case "driver_confirmed_order_was_delivered":
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//             NotificationCenter().notify('reloadOrderDetail', data: true);
//             // String order = messageData['order_type_name'] == 1 ? "đơn thường" : "đơn dự án";
//             // NotificationManager.showNotification(
//             //     dataSend,
//             //     "Tài xế ${messageData['driver_name']} đã giao đơn ${messageData['order_code']} thành công.",
//             //     "Tài xế ${messageData['driver_name']} - ${messageData['vehicle_plate']} đã hoàn thành đơn ${messageData['order_code']} thành công.. Vui lòng theo dõi hành trình trong ứng dụng.");
//             break;
//           case "project_order_expected_80%":
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//           case "system_noti_admin_customer_debt":
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//
//             // NotificationManager.showNotification(dataSend, "Đơn dự án ${messageData['order_code']} dự kiến đạt 80% tiến độ.",
//             //     "Đơn dự án mã ${messageData['order_code']} dự kiến đạt 80% tiến độ đơn hoàn thành. Vui lòng liên tục cập nhật để theo dõi thông tin tiếp theo.");
//             break;
//           case "project_order_reach_80%":
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//
//             // NotificationManager.showNotification(dataSend, "Đơn dự án ${messageData['order_code']} cần điều động thêm chuyến.",
//             //     "Đơn dự án mã ${messageData['order_code']} đã đạt 80% khối lượng. Vui lòng điều động thêm chuyến để hoàn thành tiếp đơn hàng.");
//             break;
//           case "project_order_reach_100%":
//             print(messageData['order_type']);
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             print(normal);
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//             NotificationCenter().notify('reloadOrderDetail', data: true);
//             // NotificationManager.showNotification(dataSend, "Đơn dự án ${messageData['order_code']} đã hoàn thành.",
//             //     "Đơn dự án mã ${messageData['order_code']} đã đạt hoàn thành. Vui lòng xác nhận thanh toán cho đơn hàng.");
//             break;
//           case "log_project_order_problem":
//             print(messageData['order_type']);
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             print(normal);
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//             NotificationCenter().notify('reloadOrderDetail', data: true);
//             // NotificationManager.showNotification(dataSend, "Tài xế ${messageData['driver_name']} báo cáo sự cố.",
//             //     "Đơn dự án mã ${messageData['order_code']} có tài xế ${messageData['driver_name']} - ${messageData['vehicle_plate']} gặp sự cố. Vui lòng kiểm tra thông tin.");
//             break;
//           case "driver_report_order_problem_to_admin":
//             print(messageData['order_type']);
//             bool normal = messageData['order_type'] == 2 ? false : true;
//             print(normal);
//             Map<String, dynamic> dataSend = {
//               'order_id': messageData['order_id'],
//               'normal': normal,
//               'time': messageData['time_order_created'],
//             };
//             NotificationCenter().notify('reloadOrderDetail', data: true);
//             // NotificationManager.showNotification(dataSend, "Tài xế ${messageData['driver_name']} báo cáo sự cố.",
//             //     "Đơn mã ${messageData['order_code']} có tài xế ${messageData['driver_name']} - ${messageData['vehicle_plate']} gặp sự cố. Vui lòng kiểm tra thông tin.");
//             break;
//           default:
//             break;
//         }
//       }
//
//       print("AAAAAAA");
//     } catch (e) {
//       log("$e");
//     }
//
//     return result;
//   }
// }

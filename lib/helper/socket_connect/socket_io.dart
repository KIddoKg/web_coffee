// // ignore_for_file: library_prefixes, file_names, unused_local_variable, no_leading_underscores_for_local_identifiers
//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
//
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:notification_center/notification_center.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import 'package:web_socket_channel/io.dart';
//
// class HKNSocket {
//   static final HKNSocket _instance = HKNSocket._internal();
//   static HKNSocket get instance => _instance;
//    WebSocketChannel? channel;
//    WebSocketChannel? channelA;
//   BuildContext? _context;
//   double? latitude;
//   double? longitude;
//   double? speed;
//   int? fuel;
//   int? weight;
//   bool? observation = false;
//   Map<String, dynamic> result ={};
//   Map<String, dynamic> resultA ={};
//   HKNSocket._internal();
//
//   HKNSocket initSocket(String nameLabel) {
//
//     HKNSocket.instance.disconnectWebSocket();
//     // if (channel != null) return _instance;
//     channel = IOWebSocketChannel.connect('ws://103.124.93.27:8081/ws');
//
//     log('WebSocket connected successfully!');
//     _instance.observation = true;
//
//     // channel = IOWebSocketChannel.connect('ws://103.124.93.27:8080');
//
//     channel!.stream.listen(
//           (message) {
//
//         print('ReceivedC: $message');
//         handleWebSocketMessage(message,nameLabel);
//       },
//       onDone: () {
//         _instance.observation = false;
//         print('WebSocket Channel Disconnected');
//         // You can handle reconnection logic here if needed
//       },
//       onError: (error) {
//         print('WebSocket Error: $error');
//         // Handle any errors during the WebSocket connection
//       },
//     );
//
//
//
//
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
//   HKNSocket initSocketAll() {
//     HKNSocket.instance.disconnectWebSocketAll();
//     // if (channel != null) return _instance;
//     channelA = IOWebSocketChannel.connect('ws://103.124.93.27:8081/ws');
//
//     log('WebSocket connected successfully!');
//     _instance.observation = true;
//
//     // channel = IOWebSocketChannel.connect('ws://103.124.93.27:8080');
//
//     channelA!.stream.listen(
//           (message) {
//             sendInfoTruck(message);
//         print('ReceivedB: $message');
//       },
//       onDone: () {
//         _instance.observation = false;
//         print('WebSocket Channel Disconnected');
//         // You can handle reconnection logic here if needed
//       },
//       onError: (error) {
//         print('WebSocket Error: $error');
//         // Handle any errors during the WebSocket connection
//       },
//     );
//
//
//
//
//
//     if (channelA!.closeCode == null) {
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
//
//
//    disconnectWebSocket() async {
//     if (channel != null) {
//       print(observation);
//       _instance.observation = false;
//       print(observation);
//       channel!.sink.close();
//       return true;
//     }else{
//       return false;
//     }
//   }
//   disconnectWebSocketAll() async {
//     if (channelA != null) {
//       print(observation);
//       _instance.observation = false;
//       print(observation);
//       channelA!.sink.close();
//       return true;
//     }else{
//       return false;
//     }
//   }
//
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//   Map<String, dynamic> handleWebSocketMessage(Uint8List data,String nameLabel) {
//     String message = utf8.decode(data);
//
//     // try {
//       Map<String, dynamic> messageData = jsonDecode(message);
//
//
//       String name = messageData['name'];
//
//
//       if (name == nameLabel) {
//         // Process the message only if the name is "43-1234"
//         Map<String, dynamic> gps = messageData['gps'];
//         Map<String, dynamic> sensor = messageData['sensor'];
//
//         double lat = double.tryParse(gps['lat'].toString()) ?? 0.0;
//         double lng = double.tryParse(gps['lng'].toString()) ?? 0.0;
//         double speed = double.tryParse(gps['speed'].toString()) ?? 0.0;
//
//         double fuel = double.tryParse(sensor['fuel'].toString()) ?? 0;
//         double weight = double.tryParse(sensor['weight'].toString()) ?? 0;
//         print("đ");
//         print(sensor['fuel'].toString());
//         if (fuel == 0.0) {
//           fuel = result['fuel'] ?? 0;
//         }
//
//         print('Name: $name');
//         print('Latitude: $lat');
//         print('Longitude: $lng');
//         print('Speed: $speed');
//         print('Fuel: $fuel');
//         print('Weight: $weight');
//
//         // Create a map to represent the parsed result
//         _instance.result = {
//           'name': name,
//           'latitude': lat,
//           'longitude': lng,
//           'speed': speed,
//           'fuel': fuel,
//           'weight': weight,
//         };
//         NotificationCenter().notify('updateCounter', data: result);
//         return result;
//       } else {
//         print('Ignoring message with name: $name');
//         _instance.result ={};
//         return {}; // or handle differently based on your requirements
//       }
//     // } catch (e) {
//     //   print('Error parsing message: $e');
//     //   // Return an empty map or a default value in case of an error
//     //   return {};
//     // }
//
//   }
//
//   Map<String, dynamic> sendInfoTruck(Uint8List data) {
//     String message = utf8.decode(data);
//
//     try {
//       Map<String, dynamic> messageData = jsonDecode(message);
//
//       String name = messageData['name'];
//
//         // Process the message only if the name is "43-1234"
//         Map<String, dynamic> gps = messageData['gps'];
//         Map<String, dynamic> sensor = messageData['sensor'];
//
//         double lat = double.tryParse(gps['lat'].toString()) ?? 0.0;
//         double lng = double.tryParse(gps['lng'].toString()) ?? 0.0;
//         double speed = double.tryParse(gps['speed'].toString()) ?? 0.0;
//
//         double fuel = double.tryParse(sensor['fuel'].toString()) ?? 0;
//         double weight = double.tryParse(sensor['weight'].toString()) ?? 0;
//
//         print('Name: $name');
//         print('Latitude: $lat');
//         print('Longitude: $lng');
//         print('Speed: $speed');
//         print('Fuel: $fuel');
//         print('Weight: $weight');
//
//         // Create a map to represent the parsed result
//         _instance.resultA = {
//           'name': name,
//           'latitude': lat,
//           'longitude': lng,
//           'speed': speed,
//           'fuel': fuel,
//           'weight': weight,
//         };
//         NotificationCenter().notify('checkTruck', data: messageData);
//         return resultA;
//
//     } catch (e) {
//       print('Error parsing message: $e');
//       // Return an empty map or a default value in case of an error
//       return {};
//     }
//
//   }
// }

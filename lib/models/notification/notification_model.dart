import 'package:meta/meta.dart';
import 'dart:io';

class NotificationModel {
  final String title;
  final String body;
  final String objectId;
  final String objectModel;

  NotificationModel(
      {required this.title,
      required this.body,
      required this.objectId,
      required this.objectModel});
  @override
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    if (Platform.isIOS) {
      final notification = json['aps'];
      return NotificationModel(
          title: notification['alert']['title'] ?? '',
          body: notification['alert']['body'] ?? '',
          objectId: notification['ObjectId'],
          objectModel: notification['ObjectModel']);
    } else {
      final notification = json['notification'];
      final data = json['data'];
      return NotificationModel(
          title: notification['title'] ?? '',
          body: notification['body'] ?? '',
          objectId: data['ObjectId'],
          objectModel: data['ObjectModel']);
    }
  }
}

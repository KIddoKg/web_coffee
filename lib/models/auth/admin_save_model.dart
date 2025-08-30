import 'dart:convert';

import '../../helper/save_data/appsetting.dart';




class AdminSaveModel {
  int? id;
  String? userName;
  String? email;
  String? role;
  String passwordCache = '';

  AdminSaveModel._internal();
  static final AdminSaveModel _instance = AdminSaveModel._internal();
  static AdminSaveModel get instance => _instance;

  factory AdminSaveModel.fromJson(Map<String, dynamic> json, {bool isLocalData = false}) {

    _instance.id = json['id'];
    _instance.userName = json['user_name'];
    _instance.email = json['email'];
    _instance.role = json['role'];
    _instance.passwordCache = json['passwordCache'] ?? '';
    return _instance;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _instance.id,
      'user_name': _instance.userName,
      'email': _instance.email,
      'role': _instance.role,
      'passwordCache': _instance.passwordCache,
    };
  }
  void save() {
    var json = jsonEncode(toJson());
    AppSetting.pref.setString('@profile', json);
  }
}


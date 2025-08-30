import 'dart:convert';
import '../../helper/save_data/appsetting.dart';


class DriverSaveModel {
  int? id;
  String? name;
  String? email;
  String? role;
  String passwordCache = '';

  DriverSaveModel._internal();
  static final DriverSaveModel _instance = DriverSaveModel._internal();
  static DriverSaveModel get instance => _instance;

  factory DriverSaveModel.fromJson(Map<String, dynamic> json, {bool isLocalData = false}) {

    _instance.id = json['id'];
    _instance.name = json['name'];
    _instance.email = json['email'];
    _instance.role = json['role'];
    _instance.passwordCache = json['passwordCache'] ?? '';
    return _instance;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _instance.id,
      'name': _instance.name,
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


import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSetting {
  String accessToken ="";
  String refreshToken = "";
  String version = "";
  bool ios = false;
  bool? enableAuthenLocal = true;
  int roleUser = 0;
  bool isPermission = false;

  AppSetting._internal();
  static AppSetting _instance = AppSetting._internal();
  static AppSetting get instance => _instance;
  AppLifecycleState? appLifecycleState;
  static late SharedPreferences pref;

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    _instance.accessToken = json['jwtAccessToken'] ?? "";
    _instance.refreshToken = json['jwtRefreshToken'] ?? "";
    _instance.enableAuthenLocal = json['enableAuthenLocal'] ?? false;
    _instance.roleUser = json['roleUser'] ?? 0;
    _instance.isPermission = json['isPermission'] ?? false;
    return _instance;
  }
  factory AppSetting.loadConfig(Map<String, dynamic> json) {
    // _instance.isAcceptPushNoti = json['isAcceptPushNoti'] ?? false;

    _instance.accessToken = json['jwtAccessToken'] ?? '';
    _instance.refreshToken = json['jwtRefreshToken'] ?? '';
    _instance.enableAuthenLocal = json['enableAuthenLocal'] ?? false;
    _instance.roleUser = json['roleUser'] ?? 0;
    _instance.isPermission = json['isPermission'] ?? false;

    log('appsetting.load $json');
    return _instance;
  }
  Map<String, dynamic> toJson() {
    return {
      "jwtAccessToken": _instance.accessToken,
      "jwtRefreshToken": _instance.refreshToken,
      "enableAuthenLocal": _instance.enableAuthenLocal,
      "roleUser": _instance.roleUser,
      "isPermission": _instance.isPermission,
    };
  }

  static init() async {

    pref = await SharedPreferences.getInstance();

    var hasConfig = pref.containsKey('@appSetting');
    if (hasConfig) {
      var json = pref.getString('@appSetting');
      var objJson = jsonDecode(json!);
      AppSetting.loadConfig(objJson);
    }

  }
  void save() async {
    if(Platform.isAndroid){
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      version = currentVersion;
      ios = false;
    }else{
      ios = true;
    }
    var json = _instance.toJson();
    pref.setString('@appSetting', jsonEncode(json));

    log('appsetting.save $json');
  }
  void reset() {
    pref.remove("@appSetting");
    print("reset");
    _instance.accessToken = '';
    _instance.refreshToken = '';

    log('AppSetting.reset clean profileLocal');
  }


}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SaveLocal {
  Future<void> saveToSharedPreferences(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is Map<String, dynamic>) {
      // Chuyển đổi Map<String, dynamic> thành chuỗi JSON
      String jsonString = jsonEncode(value);
      await prefs.setString(key, jsonString);
    }
  }

  Future<Map<String, dynamic>?> getMapFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      // Chuyển đổi chuỗi JSON thành Map<String, dynamic>
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> removeFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
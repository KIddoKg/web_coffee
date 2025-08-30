
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class NetworkUtility{
  static Future<String?> fetchUrl(Uri uri,{Map<String, String>? headers}) async {
    try{
      final res = await http.get(uri, headers: headers);
      if(res.statusCode == 200){
        return res.body;
      }
    }catch (e){
        if (kDebugMode) {
          print(e);
        }
    }
    return null;
  }
}
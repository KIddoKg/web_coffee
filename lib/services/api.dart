import 'package:xanh_coffee/config/env.dart';
import 'package:xanh_coffee/helper/appsetting.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../helper/di/di.dart';
import 'dio_helper.dart';

class API {
  static String identity = di<Env>().baseUrl;
  static Dio dio = Dio();

  static NetRequest refreshToken() {
    String url = '$identity/auth-owner/refresh-token';
    Map<String, String> data = {};

    data['refresh_token'] = AppSetting.instance.refreshToken;

    NetRequest req = NetRequest(url, 'post', data: data);

    return req;
  }

  static Future<NetRequest> mediaUpload(List<String> imgs) async {
    String url = '$identity/media/upload-images';
    FormData formData = FormData();
    for (int i = 0; i < imgs.length; i++) {
      String filePath = imgs[i];

      String extension = path.extension(filePath); // Ví dụ: .jpg, .png

      formData.files.add(
        MapEntry(
          'upload-images',
          await MultipartFile.fromFile(filePath, filename: 'file_$i$extension'),
        ),
      );
    }

    // Tạo NetRequest với FormData
    NetRequest req = NetRequest(
      url,
      'post',
      data: formData, // Gửi FormData
    );

    return req;
  }

  static NetRequest getWish(int page, int pageSize) {
    String url =
        '$identity/wedding/wish/get-list?page=$page&page_size=$pageSize';
    Map<String, String> data = Map();

    NetRequest req = NetRequest(url, 'get');

    return req;
  }

  static NetRequest postInvitation(String name, int guest, String note) {
    String url = '$identity/wedding/invitation';
    // Map<String, String> data = Map();

    Map<String, dynamic> data = {
      "full_name": name,
      "will_attend": true, // boolea
      "guests": guest,
      "description": note
    };

    NetRequest req = NetRequest(url, 'post', data: data);

    return req;
  }

  static NetRequest postWish(String name, String note) {
    String url = '$identity/wedding/wish';
    // Map<String, String> data = Map();

    Map<String, dynamic> data = {"user_name": name, "comment": note};

    NetRequest req = NetRequest(url, 'post', data: data);

    return req;
  }

  static NetRequest getListCMTImage(String id, int page, int pageSize) {
    String url = '$identity/wedding/comment/get-list?object_id=$id&page=$page&page_size=$pageSize&sort=-created_at';
    // Map<String, String> data = Map();

    // Map<String, dynamic> data = {"user_name": name, "comment": note};

    NetRequest req = NetRequest(url, 'get',);

    return req;
  }

  static NetRequest postCMTImage(String id, String name, String comment) {
    String url = '$identity/wedding/comment';
    // Map<String, String> data = Map();

    Map<String, dynamic> data = {"object_id": id, "user_name": name, "comment": comment};

    NetRequest req = NetRequest(url, 'post',data: data);

    return req;
  }

  static NetRequest getLinkImg(int id) {
    String url = '$identity/wedding/image/get-one/$id';
    // Map<String, String> data = Map();

    // Map<String, dynamic> data = {"user_name": name, "comment": note};

    NetRequest req = NetRequest(url, 'get',);

    return req;
  }


  static NetRequest getListImg( int page, int pageSize) {
    String url = '$identity/wedding/media/get-list?page=$page&page_size=$pageSize&sort=-created_at';
    // Map<String, String> data = Map();

    // Map<String, dynamic> data = {"user_name": name, "comment": note};

    NetRequest req = NetRequest(url, 'get',);

    return req;
  }
}

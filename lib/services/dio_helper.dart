import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:xanh_coffee/models/auth/admin_save_model.dart';
import 'package:xanh_coffee/models/auth/driver_save_model.dart';
import 'package:xanh_coffee/models/media/media_model.dart';
import 'package:xanh_coffee/models/transaction/transaction_model.dart';
import 'package:xanh_coffee/models/truck/vehicle_data_model.dart';

import '../helper/appsetting.dart';
import '../screens/home/model/comment_model.dart';
import '../screens/home/model/media_file_model.dart';
import '../screens/home/model/user_comment_model.dart';


class NetResponseList {
  int total;
  int page;
  int size;
  int pageCount;
  bool canNext = false;
  bool canPrev = false;

  NetResponseList(this.total, this.page, this.size, this.pageCount,
      this.canNext, this.canPrev);

  NetResponseList.fromJson(Map<String, dynamic> json, Map<String, dynamic> list)
      : total = json['total'],
        page = json['page'],
        size = json['size'],
        pageCount = json['pageCount'],
        canNext = json['canNext'],
        canPrev = json['canPrev'];
}

class NetResponse {
  late Map<String, dynamic>? meta;

  /// Response data Map type or orignal data
  late dynamic orignal;
  late dynamic data;
  late bool isSuccess;
  late Map<String, dynamic>? error;

  NetResponse(this.isSuccess, this.data, this.error, this.meta);

  NetResponse.fromJson(Map<String, dynamic> json)
      : meta = json['meta'],
        error = json['error'],
        data = json['data'];

  T cast<T>({Map<String, dynamic>? fromJson}) {
    var json = fromJson ?? data;
    if (T == UserCommentModel) return UserCommentModel.fromJson(json) as T;
    if (T == CommentModel) return CommentModel.fromJson(json) as T;
    if (T == MediaFileModel) return MediaFileModel.fromJson(json) as T;
    return json as T;
  }

  List<T> castList<T>({List? fromList, required fromJson}) {
    var json = fromJson ?? data;
    var listMap = (json is List) ? (json as List) : fromList;
    var lst = listMap!.map((e) => cast<T>(fromJson: e)).toList();
    return lst;
  }
}

class NetRequest {
  late String url;
  late String method;

  // late Map<String, dynamic>? data;
  late Object? data;
  late Object? form;
  late Map<String, dynamic>? header;
  CancelToken canceltoken = CancelToken();

  NetRequest(this.url, this.method, {this.header, this.data, this.form});

  late BuildContext _context;

  NetRequest setContext(BuildContext ctx) {
    _context = ctx;
    return this;
  }

  void withAuthen() async {
    header = Map<String, dynamic>();
    header!['Authorization'] = "Bearer ${AppSetting.instance.accessToken}";
  }

  // Show log debug console
  void logRequest(Dio dio) {
    if (!kReleaseMode) {
      // dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    //
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  Future<NetResponse> request() async {
    Dio dio = Dio();

    logRequest(dio);
    Options options = Options(
        method: method, headers: header, validateStatus: (status) => true);

    var response = await dio.request(url,
        cancelToken: canceltoken,
        data: data,
        options: options);

    // lỗi
    if (response.statusCode != 200) {
      if ((response.data is Map) && response.data != null) {
        var res = NetResponse.fromJson(response.data);
        res.isSuccess = false;
        return res;
      } else {
        var error = {
          "code": response.statusCode.toString(),
          'message': response.statusMessage
        };
        return NetResponse(false, null, error, null);
      }
    }

    bool isMap = response.data is Map<String, dynamic>;
    bool isMapDy = response.data is List<dynamic>;
    bool hasMeta = response.data is List &&
        response.data.isNotEmpty &&
        response.data[0].containsKey('meta');
    bool meta = hasMeta ? response.data[0]['meta'] != null : false;
    var _data = isMap
        ? response.data
        : !isMapDy
            ? response.data as String
            : response.data as List<dynamic>;
    var error = isMap ? response.data['error'] : null;
    var x =
        NetResponse(true, _data, error, meta ? response.data['meta'] : null);
    return x;
  }

  Future<List<NetResponse>> requestList() async {
    Dio dio = Dio();

    logRequest(dio);
    Options options = Options(
        method: method, headers: header, validateStatus: (status) => true);

    var response = await dio.request(url,
        cancelToken: canceltoken,
        data: data,
        options: options);

    // Handle errors
    if (response.statusCode != 200) {
      // Error handling for non-200 status code
      if ((response.data is Map) && response.data != null) {
        var res = NetResponse.fromJson(response.data);
        res.isSuccess = false;
        return [res];
      } else {
        var error = {
          "code": response.statusCode.toString(),
          'message': response.statusMessage
        };
        return [NetResponse(false, null, error, null)];
      }
    }

    // Handle response data
    if (response.data is List<dynamic>) {
      List<NetResponse> resultList = [];
      for (var itemData in response.data) {
        try {
          var item = NetResponse.fromJson(itemData);
          resultList.add(item);
        } catch (e) {
          print("Error parsing item: $e");
          resultList.add(NetResponse(
              false, null, {"message": "Error parsing item"}, null));
        }
      }
      return resultList;
    } else if (response.data is Map<String, dynamic>) {
      // If the response is a single item, parse it
      bool isMap = response.data is Map<String, dynamic>;
      var _data = isMap ? response.data : response.data as String;
      var error = isMap ? response.data['error'] : null;
      var singleItem =
          NetResponse(true, _data, error, response.data['metadata']);
      return [singleItem];
    } else {
      return [
        NetResponse(false, null, {"message": "Unexpected data format"}, null)
      ];
    }
  }

  void cancel() {
    canceltoken.cancel();
  }
}

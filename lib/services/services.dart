import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xanh_coffee/helper/socket_connect/socket_io_admin.dart';

import 'package:xanh_coffee/models/auth/admin_save_model.dart';
import 'package:xanh_coffee/models/auth/driver_save_model.dart';
import 'package:xanh_coffee/router/router_app.dart';
import 'package:xanh_coffee/router/router_string.dart';
import '../helper/save_data/appsetting.dart';

import 'package:flutter/cupertino.dart';
import '../generated/assets.gen.dart';
import '../share/share_widget.dart';
import 'api.dart';
import 'dio_helper.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xanh_coffee/generated/assets.gen.dart';
import 'package:xanh_coffee/helper/socket_connect/socket_io_admin.dart';

// import 'package:xanh_coffee/helper/socket_connect/socket_io_driver.dart';
import 'package:xanh_coffee/helper/appsetting.dart';
import 'package:xanh_coffee/router/router_app.dart';
import 'package:xanh_coffee/router/router_string.dart';
import 'package:xanh_coffee/services/api.dart';
import 'package:xanh_coffee/share/share_widget.dart';
import 'package:xanh_coffee/models/auth/admin_save_model.dart';
import 'package:xanh_coffee/models/auth/driver_save_model.dart';
// import 'package:xanh_coffee/network/net_response.dart';

class Services {
  BuildContext? _context;
  bool _isDialogShowing = false;
  int refreshTokenAttempts = 0;

  Services._internal();

  static final Services _instance = Services._internal();

  static Services get instance => _instance;

  Services setContext(BuildContext context) {
    _context = context;
    return _instance;
  }

  /// 🎯 Hiển thị alert thông báo
  Future<void> _showAlert(String title, String message,
      {void Function()? onTap}) async {
    if (_context == null) return;

    await showCupertinoDialog(
      context: _context!,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
              onTap?.call();
            },
          )
        ],
      ),
    );
  }

  /// 🎯 Đăng xuất và chuyển về màn hình đăng nhập
  // Future<void> _gotoAuthenScreen() async {
  //   AppSetting.instance.reset();
  //   await AppSetting.pref.remove('@appSetting');
  //   AppSetting.instance.accessToken = "";
  //
  //   HKNSocketDriver.instance.disconnectWebSocket();
  //   HKNSocketAdmin.instance.disconnectWebSocket();
  //
  //   navigatorState.pushNamedAndRemoveUntil(ScreenName.login, (route) => false);
  // }

  /// 🎯 Xử lý lỗi và gọi lại API nếu cần
  Future<T> _errorAction<T>(
    NetResponse res, {
    String? metaData,
    Future<T> Function()? callApi,
  }) async {
    String code = res.error?['code'] ?? '';
    String message = res.error?['message'] ?? 'Lỗi không xác định';

    log('> context: $_context');

    switch (code) {
      // case 'NotAuthenticated':
      //   closeCustomLoading();
      //
      //   // if (refreshTokenAttempts >= 5) {
      //   //   await _showAlert('Thông báo', 'Không thể làm mới token sau 5 lần thử.', onTap: _gotoAuthenScreen);
      //   //   refreshTokenAttempts = 0;
      //   //   return defaultReturnValue<T>();
      //   // }
      //   //
      //   // refreshTokenAttempts++;
      //   // log('🔄 Thử làm mới token lần: $refreshTokenAttempts');
      //
      //   var refreshRes = await refreshToken();
      //   if (!refreshRes.isSuccess) {
      //     // await _showAlert('Thông báo', 'Hết thời gian đăng nhập. [Mã: $code]', onTap: _gotoAuthenScreen);
      //
      //     showCustomDialog(
      //       context: _context!,
      //       imageAsset: Assets.img.bgFail.keyName,
      //       title: "Hết thời gian đăng nhập.",
      //       errorsMessage: '[Mã: $code]',
      //       onContinue: _gotoAuthenScreen,
      //       onHome: _gotoAuthenScreen
      //     );
      //     refreshTokenAttempts = 0;
      //   } else {
      //     refreshRes.cast<AppSetting>(fromJson: refreshRes.data['data']);
      //     AppSetting.pref.setString('appsetting', json.encode(AppSetting.instance.toJson()));
      //
      //     if (callApi != null) {
      //       return await callApi();
      //     }
      //   }
      //   break;

      // case 'NotAuthenticatedT':
      //   // closeCustomLoading();
      //   // await _showAlert('Thông báo', 'Hết thời gian đăng nhập. [Mã: $code]', onTap: _gotoAuthenScreen);
      //   closeCustomLoading();
      //   if (!_isDialogShowing) {
      //     _isDialogShowing = true;
      //     showCustomDialog(
      //       context: _context!,
      //       imageAsset: Assets.img.bgFail.keyName,
      //       title: message,
      //       errorsMessage: 'Thất bại',
      //       onContinue: () {
      //         _isDialogShowing = false;
      //         Navigator.pop(_context!);
      //       },
      //       onHome: () {
      //         _isDialogShowing = false;
      //         navigatorState.pushNamedAndRemoveUntil(
      //           AppSetting.instance.roleUser == 0 ? ScreenName.dashboard : ScreenName.homeDriver,
      //           (route) => false,
      //         );
      //       },
      //     );
      //   }
      //
      //   break;

      default:
        closeCustomLoading();
        if (!_isDialogShowing) {
          _isDialogShowing = true;
          // showCustomDialog(
          //   context: _context!,
          //   imageAsset: Assets.img.bgFail.keyName,
          //   title: message,
          //   errorsMessage: 'Thất bại',
          //   onContinue: () {
          //     _isDialogShowing = false;
          //     Navigator.pop(_context!);
          //   },
          //   onHome: () {
          //     _isDialogShowing = false;
          //     navigatorState.pushNamedAndRemoveUntil(
          //       AppSetting.instance.roleUser == 0 ? ScreenName.dashboard : ScreenName.homeDriver,
          //       (route) => false,
          //     );
          //   },
          // );

          _showAlert("Thông báo", message);
        }
        break;
    }

    return defaultReturnValue<T>();
  }

  /// 🎯 Giá trị mặc định khi lỗi
  T defaultReturnValue<T>() {
    if (T == bool) return false as T;
    if (T == int) return 0 as T;
    return null as T;
  }

  /// 🎯 Làm mới token
  Future<NetResponse> refreshToken() async {
    var res = await API.refreshToken().request();
    if (!res.isSuccess) {
      await _errorAction(res);
    }
    return res;
  }

  Future<NetResponse> getWish(int page, int pageSize) async {
    var res = await API.getWish(page, pageSize).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getWish(page, pageSize);
      });
    }
  }

  Future<bool> postInvitation(String name, int guest, String note) async {
    var res = await API.postInvitation(name, guest, note).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return postInvitation(name, guest, note);
      });
    }
  }

  Future<bool> postWish(String name, String note) async {
    var res = await API.postWish(name, note).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return postWish(name, note);
      });
    }
  }

  Future<NetResponse> getListCMTImage(
      String name, int page, int pageSize) async {
    var res = await API.getListCMTImage(name, page, pageSize).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getListCMTImage(name, page, pageSize);
      });
    }
  }

  Future<NetResponse> getLinkImg(int name) async {
    var res = await API.getLinkImg(name).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getLinkImg(name);
      });
    }
  }  Future<NetResponse> getListImg( int page, int pageSize  ) async {
    var res = await API.getListImg(page,pageSize).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getListImg( page,pageSize);
      });
    }
  }

  Future<NetResponse> postCMTImage(String id, String name, String cmt) async {
    var res = await API.postCMTImage(id, name,cmt).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return postCMTImage(id, name,cmt);
      });
    }
  }
}

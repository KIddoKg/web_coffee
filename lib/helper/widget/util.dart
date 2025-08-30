import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
// import 'package:is_first_run/is_first_run.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../router/router_app.dart';
import '../../share/share_widget.dart';

OverlaySupportEntry? _loadingOverlayEntry;

@lazySingleton
class WidgetUtil {
  void showGlobalLoadingOverlay() {
    dismissGlobalLoadingOverlay();
    _loadingOverlayEntry = showOverlay((_, __) => const KSLoadingIndicator(),
        duration: const Duration(hours: 100));
  }

  void dismissGlobalLoadingOverlay() {
    _loadingOverlayEntry?.dismiss(animate: false);
  }

  void closeGlobalKeyboard({BuildContext? context}) {
    if (context != null) {
      FocusScope.of(context).unfocus();
      return;
    }
    FocusScope.of(navigatorKey.currentContext!).requestFocus(FocusNode());
  }

  bool checkLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  bool checkKeyboardOpening(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom != 0;

  Future<dynamic> showCenterDialog(
      {required BuildContext context,
        required Widget child,
        bool barrierDismissible = true}) {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
        useRootNavigator: true);
  }

  Future<dynamic> showFullScreenDialog(
      {required BuildContext context, required Widget child}) {
    return showDialog(
        context: context, builder: (_) => child, useRootNavigator: true);
  }

  bool hasPaddingBottom(BuildContext context) =>
      MediaQuery.of(context).padding.bottom != 0;

  // Future<bool> isFirstRun() => IsFirstRun.isFirstRun();

  double getPaddingBottom(BuildContext context) {
    if (hasPaddingBottom(context)) {
      return 32;
    }
    return 16;
  }

  double getWidthDevice(BuildContext context) =>
      MediaQuery.of(context).size.width;
  double getHeightDevice(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

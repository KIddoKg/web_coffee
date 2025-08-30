import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? pausedCallBack;
  final AsyncCallback? inactiveCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.pausedCallBack,
    this.inactiveCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        print('resumed');
        break;
      case AppLifecycleState.inactive:
        if (inactiveCallBack != null) {
          await inactiveCallBack!();
          
        }
        print('inactive');
        break;
      case AppLifecycleState.paused:
        if (pausedCallBack != null) {
          await pausedCallBack!();
        }
        print('paused');
        break;
      case AppLifecycleState.detached:
        print('detached');
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
}

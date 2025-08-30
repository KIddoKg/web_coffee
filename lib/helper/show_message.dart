import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bot_toast/bot_toast.dart';


import '../models/notification/notification_model.dart';
import '../share/share_widget.dart';
import '../theme/app_theme.dart';

class Message {
  static showToastMessage(BuildContext context, String title) {
    FToast fToast = FToast();
    fToast.init(context);
    Future.delayed(Duration.zero, () async {
      fToast.showToast(
        child: ToastMessage(title: title),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    });
  }

  static showNotificationMessage(
      {required NotificationModel model, required NotificationCallback callback}) {
    BotToast.showCustomNotification(
        animationDuration: Duration(milliseconds: 200),
        animationReverseDuration: Duration(milliseconds: 200),
        duration: Duration(seconds: 3),
        toastBuilder: (cancel) {
          return NotificationMessage(
            model: model,
            callback: (model) {
              cancel();
              callback(model);
            },
          );
        });
  }
}

class ToastMessage extends StatelessWidget {
  final String title;
  ToastMessage({required this.title});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 80),
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                )
              ]),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 24, color: Colors.white),
              SizedBox(width: 16),
              Expanded(
                child:    KSText(title,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          )),
    );
  }
}

typedef NotificationCallback = Function(NotificationModel);

class NotificationMessage extends StatefulWidget {
  final NotificationCallback callback;
  final NotificationModel model;

  const NotificationMessage({required this.model, required this.callback});

  @override
  _NotificationMessage createState() => _NotificationMessage();
}

class _NotificationMessage extends State<NotificationMessage> {
  String icon = 'assets/imagess/banner.png';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18, right: 18),
      child: GestureDetector(
        onTap: () {
          widget.callback(widget.model);
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    )
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    icon,
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: widget.model.body.isEmpty
                            ? [
                                   KSText(
                                  widget.model.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                )
                              ]
                            : [
                                   KSText(
                                  widget.model.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4),
                                   KSText(
                                  widget.model.body,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 2,
                                )
                              ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


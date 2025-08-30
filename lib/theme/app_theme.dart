import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      fontFamily: nunitoSansRegular,
      platform: TargetPlatform.iOS,
      primaryColor: Colors.white,
      indicatorColor: primaryColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: primaryColor,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        // brightness: Brightness.light,
        // textTheme: TextTheme(
        //     headline6: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white))
        titleTextStyle: TextTheme().titleLarge
      ),
      primaryIconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.light);
}

Color primaryColor = Color(0xFF025ca6);
Color backgroundColor = Color(0xFFf2f2f4);
Color primaryGreyColor = Colors.grey;
Color primaryLightGreyColor = Colors.grey[200]!;

String nunitoSansRegular = 'NunitoSansRegular';
String nunitoSansSemiBold = 'NunitoSansSemiBold';
String nunitoSansBold = 'NunitoSansBold';

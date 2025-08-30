import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// for responsive design
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeH;
  static double? blockSizeV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeH = screenWidth! / 100;
    blockSizeV = screenHeight! / 100;
  }

  static double iconSize = 0.04*screenWidth!;
  static double buttonSize = 0.06*screenWidth!;
  static double logoSize = 0.09*screenWidth!;
  static double radiusSize = 0.08*screenWidth!;
}

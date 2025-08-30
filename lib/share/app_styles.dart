import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xanh_coffee/helper/format/helper.dart';

const Color kPrimaryColor = Color(0xffFC9D45);
const Color kSecondaryColor = Color(0xff573353);
const Color kScaffoldBackground = Color(0xffFFF3E9);

class AppStyle {
  AppStyle._();

  static TextEditingController testField = TextEditingController();
  static TextEditingController testFieldSearch = TextEditingController();

  static const Color background = Color.fromRGBO(250, 250, 250, 1);
  static const Color secondary = Color(0XFFFF69B4);
  static const Color accent = Color(0XFF03A89E);
  static const Color text = Color(0XFF06152B);
  static const Color textLight = Color(0XFF99B2C6);
  static const Color lightNeutral = Color(0xFFEEEEEE);
  static const Color lightNeutral5 = Color(0xFFF8F8F8);
  static const Color lightNeutral10 = Color(0xFFDCDCDC);
  static const Color lightNeutral40 = Color(0xFF585858);
  static const Color textColorLightTheme = Color(0xFF0D0D0E);

  static Color primary = '#7E1717'.toColor();
  static Color primaryNeutral = const Color(0XFFFFFFFF).withOpacity(0.65);
  static Color whiteBg = Colors.white;
  static Color whiteYellow = const Color.fromRGBO(250, 240, 230, 1.0);
  static Color blackLite = const Color.fromRGBO(30, 30, 30, 1.0);
  static Color greyBg = Colors.grey;
  static Color backgroundCardColor = '#FCFCFD'.toColor();
  static Color borderCardColor = '#E0E0E0'.toColor();
  static Color backgroundColor = '#f2f2f4'.toColor();
  static Color primaryRedOr = '#fd5f32'.toColor();
  static Color primaryColor = '#2F67B2'.toColor();
  static Color primaryColorOpacity = '#E0F1FF'.toColor();
  static Color primaryColorWord = '#B5CB99'.toColor();
  static Color primaryColorPink = '#B2533E'.toColor();
  static Color primaryColorYellowW = '#F5EEC8'.toColor();
  static Color primaryColorBlack = '#000000'.toColor();
  static Color primaryColorYellow = '#FCE09B'.toColor();
  static Color primaryColorGrey = '#D0D4CA'.toColor();
  static Color primaryGrayWord = '#727272'.toColor();
  static Color primaryGray = '#B9B9B9'.toColor();
  static Color primaryGrayBroder = '#E8E8E8'.toColor();
  static Color primaryGrayTime = '#A1A1A1'.toColor();
  static Color primaryGrayLight = '#D9D9D9'.toColor();
  static Color primaryGrayLight2 = const Color.fromRGBO(130, 130, 130, 0.7);
  static Color primaryGray242424 = '#242424'.toColor();
  static Color primaryGrayIcon = '#8A8A8A'.toColor();
  static Color primaryGrayOTP = '#F2F2F2'.toColor();
  static Color primaryGray_999999 = '#999999'.toColor();
  static Color primaryGrayB8C1B2 = '#B8C1B2'.toColor();
  static Color primaryGray8D8D8D = '#8D8D8D'.toColor();
  static Color primaryGrayD8DDE6 = '#D8DDE6'.toColor();
  static Color primaryGray90998B = '#90998B'.toColor();
  static Color primaryGray91929E = '#91929E'.toColor();
  static Color primaryGrayA0AEC0 = '#A0AEC0'.toColor();
  static Color primaryGray_197_198_215 =
      const Color.fromRGBO(187, 198, 215, 1.0);
  static Color primaryGray_245_246_249 =
      const Color.fromRGBO(245, 246, 249, 1.0);
  static Color primaryGrayChat = '#F6F6F6'.toColor();
  static Color primaryGreen = '#419F7D'.toColor();
  static Color primaryGreenLight = '#F6FFED'.toColor();
  static Color primaryGreen11150F = '#11150F'.toColor();
  static Color primaryGreen647B58 = '#647B58'.toColor();
  static Color primaryGreen52C41A = '#52C41A'.toColor();
  static Color primaryGreen617855 = '#617855'.toColor();
  static Color primaryGreenCAD1C6 = '#CAD1C6'.toColor();
  static Color primaryGreen41483D = '#41483D'.toColor();
  static Color primaryGreen49AA19 = '#49AA19'.toColor();
  static Color primaryGreen617856 = '#617856'.toColor();
  static Color primaryGreen_0_81_49 = const Color.fromRGBO(0, 81, 49, 1.0);
  static Color primaryGrayBlue = '#002766'.toColor();
  static Color primaryOrange = '#FA541C'.toColor();
  static Color primaryPinkFFD6E7 = '#FFD6E7'.toColor();
  static Color primaryGreenD9F7BE = '#D9F7BE'.toColor();
  static Color primaryBlueEBF1FA = '#EBF1FA'.toColor();
  static Color primaryBlue002766E0 = '#002766'.toColor();
  static Color primaryBlueB5F5EC = '#B5F5EC'.toColor();
  static Color primaryBlue13C2C2 = '#13C2C2'.toColor();
  static Color primaryBlueE6F7FF = '#E6F7FF'.toColor();
  static Color primaryBlue060B28BD = '#060B28BD'.toColor();
  static Color primaryBlue0A0E23B5 = '#0A0E23B5'.toColor();
  static Color primaryBlue2FB8FF = '#2FB8FF'.toColor();
  static Color primaryBlue9EECD9 = '#9EECD9'.toColor();
  static Color primaryBlue060C29 = '#060C29'.toColor();
  static Color primaryBlue040C30 = '#040C30'.toColor();

  static Color primaryBlueDisable = const Color.fromRGBO(157, 179, 214, 1.0);
  static Color primaryVioletF9F0FF = '#F9F0FF'.toColor();
  static Color primaryOrangeFFE7BA = '#FFE7BA'.toColor();
  static Color primaryOrangeFA541C = '#FA541C'.toColor();
  static Color primaryOrangeFFD8BF = '#FFD8BF'.toColor();
  static Color primaryYellowFFFBE6 = '#FFFBE6'.toColor();
  static Color primaryYellowFAAD14 = '#FAAD14'.toColor();
  static Color primaryYellowFEFFE6 = '#FEFFE6'.toColor();
  static Color primaryYellowFA8C16 = '#FA8C16'.toColor();
  static Color primaryYellowFADB14 = '#FADB14'.toColor();
  static Color primaryRedEB2F96 = '#EB2F96'.toColor();
  static Color primaryRedFA541C = '#FA541C'.toColor();
  static Color primaryRedFF4D4F = '#FF4D4F'.toColor();
  static Color primaryViolet722ED1 = '#722ED1'.toColor();

  static const Color bgButton = Color.fromRGBO(209, 209, 209, 1.0);

  static double? sizeUI;
  static double? bottomNav;
  static double? bottomArea;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static void init() {
    if (Platform.isIOS) {
      sizeUI = 255;
      bottomArea = 40;
      bottomNav = 0;
    } else if (Platform.isAndroid) {
      sizeUI = 260;
      bottomNav = 18;
      bottomArea = 0;
    }
  }

  static EdgeInsets padding_all_8() {
    return const EdgeInsets.all(8.0);
  }

  static EdgeInsets padding_all_16() {
    return const EdgeInsets.all(16.0);
  }

  static EdgeInsets padding_LR_8() {
    return const EdgeInsets.only(left: 8.0, right: 8.0);
  }

  static EdgeInsets padding_LR_16() {
    return const EdgeInsets.only(left: 16.0, right: 16.0);
  }

  static EdgeInsets padding_LR_64() {
    return const EdgeInsets.only(left: 64.0, right: 64.0);
  }

  static EdgeInsets padding_LR_32() {
    return const EdgeInsets.only(left: 32.0, right: 32.0);
  }

  static EdgeInsets padding_TB_8() {
    return const EdgeInsets.only(top: 8.0, bottom: 8.0);
  }

  static EdgeInsets padding_TB_4() {
    return const EdgeInsets.only(top: 4.0, bottom: 4.0);
  }

  static EdgeInsets padding_TB_16() {
    return const EdgeInsets.only(top: 16.0, bottom: 16.0);
  }

// static const Color bgButton = Color.fromRGBO(	204, 204, 204, 1.0);

  static Color getRandomColor() {
    final random = Random();

    // List of predefined colors
    List<Color> colorSamples = [
      primaryPinkFFD6E7,
      primaryGreenD9F7BE,
      primaryBlueEBF1FA,
      primaryOrangeFFE7BA,
    ];

    // Randomly pick one color from the list
    return colorSamples[random.nextInt(colorSamples.length)];
  }
}

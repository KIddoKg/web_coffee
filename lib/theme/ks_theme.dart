import 'package:flutter/material.dart';

import '../share/text_style.dart';

abstract class KSThemeData {
  final Color primaryColor = const Color(0xFF419F7D);
  final Color c121212 = const Color(0xFF121212);
  final Color e8e8e8 = const Color(0xFFE8E8E8);
  final Color b9b9b9 = const Color(0xFFB9B9B9);
  final Color f2f2f2 = const Color(0xFFF2F2F2);
  final Color c8a8a8a = const Color(0xFF8A8A8A);
  final Color c186ade = const Color(0xFF186ADE);
  final Color c727272 = const Color(0xFF727272);
  final Color fafafa = const Color(0xFFFAFAFA);
  final Color a1a1a1 = const Color(0xFFA1A1A1);
  final Color d91f11 = const Color(0xFFD91F11);
  final Color eeeeee = const Color(0xFFEEEEEE);
  final Color c373737 = const Color(0xFF373737);
  final Color c389e0d = const Color(0xFF389E0D);
  final Color d99511 = const Color(0xFFD99511);
  final Color f8f8f8 = const Color(0xFFF8F8F8);
  final Color e30808 = const Color(0xFFE30808);
  final Color b9ecd9 = const Color(0xFFB9ECD9);
  final Color fef6e6 = const Color(0xFFFEF6E6);
  final Color feeeed = const Color(0xFFFEEEED);
  final Color c7a7a7a = const Color(0xFF7A7A7A);
  final Color c333333 = const Color(0xFF333333);
  final Color c515151 = const Color(0xFF515151);
  final Color f6f6f6 = const Color(0xFFF6F6F6);
  final Color ecfbf5 = const Color(0xFFECFBF5);
  final Color fff7ec = const Color(0xFFFFF7E5);
  final Color fabd14 = const Color(0xFFFABD14);
  final Color fa541c = const Color(0xFFFA541C);
  final Color fff7e5 = const Color(0xFFFFF7E5);
  final Color c6f6f6f = const Color(0xFF6F6F6F);
  final Color c595454 = const Color(0xFF595454);
  final Color c2c2c2 = const Color(0xFFC2C2C2);
  final Color e20909 = const Color(0xFFE20909);
  final Color c419f7d = const Color(0xFF419F7D);
  final Color b3b6bb = const Color(0xFFB3B6BB);
  final Color fa5343 = const Color(0xFFFA5343);

  final Color systemGreen = const Color(0xff429E46);
  final Color secondaryColor = const Color(0xFF242F36);
  final Color labelColor = const Color(0xff7F7F7F);
  final Color dodgerBlue = const Color(0xff307EF3);
  Color get link;
  Color get warning;
  Color get border;
  Color get labelLight;
  Color get buttonSwitchGrey => const Color.fromRGBO(120, 120, 120, 0.32);
  Color get shadowColor;
  Color get shadowColor2;
  Color get barrierColor;

  Color get skeletonBaseColor;
  Color get skeletonHighlightColor;

  final Color textUnhighlight = const Color(0xFFC0C0C0);

  //blue
  final Color blue50 = const Color(0xFFE8F4FF);
  final Color blue100 = const Color(0xFFB7DDFF);
  final Color blue300 = const Color(0xFF1890FF);

  final Color green900 = const Color(0xff1C421D);
  final Color green800 = const Color(0xff245727);
  final Color green700 = const Color(0xff2F7032);
  final Color green600 = const Color(0xff3C9040);
  final Color green500 = const Color(0xff429E46);
  final Color green400 = const Color(0xff68B16B);
  final Color green300 = const Color(0xff80BE83);
  final Color green200 = const Color(0xffA8D2AA);
  final Color green100 = const Color(0xffC4E1C6);
  final Color green50 = const Color(0xffECF5ED);

  final Color grey900 = const Color(0xff1A1E2A);
  final Color grey800 = const Color(0xff222738);
  final Color grey700 = const Color(0xff2C3248);
  final Color grey600 = const Color(0xff38415C);
  final Color grey500 = const Color(0xff3E4765);
  final Color grey400 = const Color(0xff656C84);
  final Color grey300 = const Color(0xff7E8498);
  final Color grey200 = const Color(0xffA6AAB8);
  final Color grey100 = const Color(0xffC3C6CF);
  final Color grey50 = const Color(0xffECEDF0);
  final Color grey7F7F7F = const Color(0xFF7F7F7F);
  final Color grey242F36 = const Color(0xFF242F36);
  final Color systemBlueLight = const Color(0xff007AFF);
  final Color systemRedLight = const Color(0xffFF3B30);
  final Color successColor = const Color(0xff00A36C);
  final Color upcomingColor = const Color(0xffE87C19);

  //orange
  final Color orange500 = const Color(0xffE9A13B);
  final Color orange300 = const Color(0xffF0C07C);
  final Color orange50 = const Color(0xffFDF6EB);

  final Color redFF0404 = const Color(0xFFFF0404);
  final Color red9B111E = const Color(0xFF9B111E);
  final Color redE72739 = const Color(0xFFE72739);
  final Color red500 = const Color(0xffFF4842);
  final Color red700 = const Color(0xffB5332F);
  final Color redE0115f = const Color(0xFFe0115f);

  //#region Chat
  final Color mainBackgroundColor = const Color(0xffffffff);
  // final Color mainBlackColor = const Color(0xff121212);
  final Color mainBlackColor = const Color(0xff000000);
  final Color redDarkmodeColor = const Color(0xffe72739);
  final Color offlineColor = const Color(0xffC0C0C0);
  final Color onlineColor = const Color(0xff33FF00);
  final Color myMessageBackgroundColor = const Color(0xffD9D9D9);
  final Color anotherMessageBackgroundColor = Colors.white;
  final Color lightModeTextColor = const Color(0xff7F7F7F);
  //#endregion
  final Color fullBlack = const Color(0xFF000000);

  final Color backgroundColor = const Color(0xFFF5F5F5);

  final Color backgroundColor2 = const Color(0xffFAFAFA);
}

class DSLightThemeData extends KSThemeData {
  @override
  Color get barrierColor => const Color(0xff020D1B);

  @override
  Color get border => const Color(0xFFFFFFFF);

  @override
  Color get link => const Color(0xff00FFFF);

  @override
  Color get shadowColor => const Color(0xffB8C2DA);

  @override
  Color get shadowColor2 => const Color(0xff103763);

  @override
  Color get skeletonBaseColor => const Color(0xffECEDF0);

  @override
  Color get skeletonHighlightColor => const Color(0xffF5F5F5);

  @override
  Color get warning => const Color(0xffFF4842);

  @override
  Color get labelLight => const Color(0xff3C3C43);
}

class DSDarkThemeData extends KSThemeData {
  @override
  Color get barrierColor => const Color(0xff020D1B);

  @override
  Color get border => const Color(0xFFFFFFFF);

  @override
  Color get link => const Color(0xff1890FF);

  @override
  Color get shadowColor => const Color(0xffB8C2DA);

  @override
  Color get shadowColor2 => const Color(0xff103763);

  @override
  Color get skeletonBaseColor => const Color(0xffECEDF0);

  @override
  Color get skeletonHighlightColor => const Color(0xffF5F5F5);

  @override
  Color get warning => const Color(0xffFF4842);

  @override
  Color get labelLight => const Color(0xff3C3C43);
}

// ignore: must_be_immutable
class KSTheme extends InheritedWidget {
  KSTheme({required Widget child, Key? key}) : super(child: child, key: key);

  KSThemeData? _theme;

  KSThemeData get color {
    _theme ??= _lightTheme;
    return _theme!;
  }

  bool _isLightTheme = true;
  bool get isLightTheme => _isLightTheme;

  final KSThemeData _lightTheme = DSLightThemeData();
  final KSThemeData _darkTheme = DSDarkThemeData();

  final KSTextStyle _style = KSTextStyle();
  KSTextStyle get style => _style;

  void changeToDarkTheme() {
    _theme = _darkTheme;
    _isLightTheme = false;
  }

  void changeToLightTheme() {
    _theme = _darkTheme;
    _isLightTheme = true;
  }

  void toggleTheme() {
    if (isLightTheme) {
      changeToDarkTheme();
    } else {
      changeToLightTheme();
    }
  }

  /// About `covariant` keyword:
  ///     Valid reason to use a [KSTheme] subtype instead [InheritedWidget]
  ///
  /// See: https://dart.dev/guides/language/sound-problems
  @override
  bool updateShouldNotify(covariant KSTheme oldWidget) =>
      oldWidget.isLightTheme != isLightTheme;

  static KSTheme of(BuildContext context) {
    final KSTheme? result =
    context.dependOnInheritedWidgetOfExactType<KSTheme>();
    assert(result != null, 'No KSTheme found in context');
    return result!;
  }
}

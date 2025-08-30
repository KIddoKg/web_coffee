import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:xanh_coffee/generated/fonts.gen.dart';
// Nếu dùng Google Fonts sau này
import 'package:google_fonts/google_fonts.dart';

class KSFontFamily {
  static const String defaultFont = FontFamily.playfairDisplay;
// Sau này nếu chuyển Google Fonts, bạn có thể dùng tên font trong Google Fonts package hoặc thay logic
}



class KSTextStyle {
  const KSTextStyle._();

  static const KSTextStyle _instance = KSTextStyle._();

  factory KSTextStyle() => _instance;

  /// Hàm tạo TextStyle chung với font tùy chọn
  TextStyle style(
      double fontSize,
      FontWeight fontWeight, {
        TextStyle Function({
        double? fontSize,
        FontWeight? fontWeight,

        })? fontBuilder,
      }) {
    final builder = fontBuilder ?? GoogleFonts.playfairDisplay;
    return builder(
      fontSize: fontSize,
      fontWeight: fontWeight,

    );
  }

  /// Shortcut: dùng nhanh với các font phổ biến

  // ✅ Danh sách TextStyle đã đơn giản hóa tên biến
  TextStyle get ts8w400 => style(8, FontWeight.w400);
  TextStyle get ts10w400 => style(10, FontWeight.w400);
  TextStyle get ts10w700 => style(10, FontWeight.w700);
  TextStyle get ts12w400 => style(12, FontWeight.w400);
  TextStyle get ts12w500 => style(12, FontWeight.w500);
  TextStyle get ts12w600 => style(12, FontWeight.w600);
  TextStyle get ts12w700 => style(12, FontWeight.w700);
  TextStyle get ts13w500 => style(13, FontWeight.w500);
  TextStyle get ts14w300 => style(14, FontWeight.w300);
  TextStyle get ts14w400 => style(14, FontWeight.w400);
  TextStyle get ts14w500 => style(14, FontWeight.w500);
  TextStyle get ts14w600 => style(14, FontWeight.w600);
  TextStyle get ts14w700 => style(14, FontWeight.w700);
  TextStyle get ts15w400 => style(15, FontWeight.w400);
  TextStyle get ts15w500 => style(15, FontWeight.w500);
  TextStyle get ts15w600 => style(15, FontWeight.w600);
  TextStyle get ts15w700 => style(15, FontWeight.w700);
  TextStyle get ts16w400 => style(16, FontWeight.w400);
  TextStyle get ts16w500 => style(16, FontWeight.w500);
  TextStyle get ts16w600 => style(16, FontWeight.w600);
  TextStyle get ts16w700 => style(16, FontWeight.w700);
  TextStyle get ts17w600 => style(17, FontWeight.w600);
  TextStyle get ts17w700 => style(17, FontWeight.w700);
  TextStyle get ts18w400 => style(18, FontWeight.w400);
  TextStyle get ts18w500 => style(18, FontWeight.w500);
  TextStyle get ts18w700 => style(18, FontWeight.w700);
  TextStyle get ts20w400 => style(20, FontWeight.w400);
  TextStyle get ts20w700 => style(20, FontWeight.w700);
  TextStyle get ts20w900 => style(20, FontWeight.w900);
  TextStyle get ts22w500 => style(22, FontWeight.w500);
  TextStyle get ts22w300 => style(22, FontWeight.w300);
  TextStyle get ts22w700 => style(22, FontWeight.w700);
  TextStyle get ts22w900 => style(22, FontWeight.w900);
  TextStyle get ts23w500 => style(23, FontWeight.w500);
  TextStyle get ts24w500 => style(24, FontWeight.w500);
  TextStyle get ts24w700 => style(24, FontWeight.w700);
  TextStyle get ts24w900 => style(24, FontWeight.w900);
  TextStyle get ts26w900 => style(26, FontWeight.w900);
  TextStyle get ts26w700 => style(26, FontWeight.w700);
  TextStyle get ts26w300 => style(26, FontWeight.w300);
  TextStyle get ts28w400 => style(28, FontWeight.w400);
  TextStyle get ts28w700 => style(28, FontWeight.w700);
  TextStyle get ts28w900 => style(28, FontWeight.w900);
  TextStyle get ts35w500 => style(35, FontWeight.w500);
  TextStyle get ts35w600 => style(35, FontWeight.w600);
  TextStyle get ts38w600 => style(38, FontWeight.w600);
  TextStyle get ts42w500 => style(42, FontWeight.w500);
  TextStyle get ts42w600 => style(42, FontWeight.w600);
  TextStyle get ts50w500 => style(50, FontWeight.w500);
  TextStyle get ts60w500 => style(60, FontWeight.w500);
  TextStyle get ts70w500 => style(70, FontWeight.w500);
  TextStyle get ts80w500 => style(80, FontWeight.w500);
  TextStyle get ts120w700 => style(120, FontWeight.w700);
}

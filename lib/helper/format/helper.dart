import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_theme.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';

extension DoubleNumberExtension on double {
  String spaceSeparateNumbers() {
    var f = NumberFormat('#,##0');
    return f.format(this);
  }
}

extension DateStringExtension on String {
  /// Chuyển ISO string "2025-2-10T00:00:00" → "10/02/2025"
  String toFormattedDate({String format = 'dd/MM/yyyy'}) {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      // Nếu parse lỗi, trả về chính string gốc
      return this;
    }
  }
}

extension NumberFormatting on num {
  /// Định dạng số thành dạng có dấu phẩy phân cách hàng nghìn
  String formatWithCommas() {
    final parts = toStringAsFixed(2).split('.'); // Tách phần nguyên và phần thập phân
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Thêm dấu phẩy phân cách hàng nghìn cho phần nguyên
    final formattedIntegerPart = integerPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    return '$formattedIntegerPart.$decimalPart';
  }

  String formatWithCommasAndUnit() {
    final parts = toStringAsFixed(2).split('.'); // Tách phần nguyên và phần thập phân
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Thêm dấu phẩy phân cách hàng nghìn cho phần nguyên
    final formattedIntegerPart = integerPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    return '$formattedIntegerPart.$decimalPart đ';
  }
}

extension IntegerNumberExtension on int {
  String toCurrencyInt({subfix = ' đ'}) {
    var f = NumberFormat('###.###');
    return f.format(this) + subfix;
  }
}

 

extension doubleNumberExtension on double {
  String toCurrency({String suffix = ' đ', String locale = 'vi_VN'}) {
    bool hasDecimal = this % 1 != 0; // Kiểm tra xem có phần thập phân không
    int decimalDigits = hasDecimal ? 2 : 0; // Hiển thị tối đa 2 chữ số nếu có phần thập phân

    final format = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: decimalDigits,
    );

    return '${format.format(this).trim()}$suffix';
  }
}





// string_extensions.dart
extension toCapitalize on String {
  String capitalizeFirstLetter() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1);
  }

  String capitalizeEachWord() {
    if (this.isEmpty) return this;
    return this.split(' ').map((word) => word.capitalizeFirstLetter()).join(' ');
  }
}

extension DatetimeExtesion on DateTime {
  DateTime lastDateOfMouth() {
    var now = DateTime.now();

// Find the last day of the month.
    var lastDayDateTime = (now.month < 12) ? DateTime(now.year, now.month + 1, 0) : DateTime(now.year + 1, 1, 0);

    print(lastDayDateTime.day); // 28 for February

    return lastDayDateTime;
  }

  String toWeekdayString({
    List<String>? formatWeeks,
  }) {
    var defaultWeek = formatWeeks ??= ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return defaultWeek[weekday - 1];
  }

  static String weekdayStringFrom({required DateTime date, List<String>? formatWeeks}) {
    var defaultWeek = formatWeeks ??= ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return defaultWeek[date.weekday - 1];
  }
}

extension CapExtension on String {
  String toUpFirstCase() => isNotEmpty ? '${this[0].toLowerCase()}${substring(1)}' : '';

  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.toUpFirstCase).join(" ");

  String get getProductCodeFromUrl {
    var code = this;
    var isURL = Uri.tryParse(code)?.hasAbsolutePath ?? false;
    if (isURL) {
      List lst = code.split('/');
      var productCode = lst.last.split('-').last;
      return productCode;
    } else {
      return '';
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  Color hex(String hexString) {
    var c = hexString.replaceAll('#', '0xff');
    return Color(int.parse(c));
  }

  MaterialColor toMaterialColor() {
    MaterialColor colorSwatch = MaterialColor(
      value,
      <int, Color>{
        50: withAlpha((255 * 0.1).toInt()),
        100: withAlpha((255 * 0.2).toInt()),
        200: withAlpha((255 * 0.3).toInt()),
        300: withAlpha((255 * 0.4).toInt()),
        400: withAlpha((255 * 0.5).toInt()),
        500: withAlpha((255 * 0.6).toInt()),
        600: withAlpha((255 * 0.7).toInt()),
        700: withAlpha((255 * 0.8).toInt()),
        800: withAlpha((255 * 0.9).toInt()),
        900: withAlpha((255 * 1).toInt()),
      },
    );
    return colorSwatch;
  }
}

extension StringColor on String {
  /// required string color has '#...'
  ///
  /// Return color
  Color toColor() {
    if (isEmpty) return Colors.white;

    var c = replaceAll('#', '0xff');
    return Color(int.parse(c));
  }
}

extension DateTimeExtensions on DateTime {
  // Chuyển đổi DateTime thành milliseconds từ epoch trong UTC
  int toEpochMilliseconds() {
    // Kiểm tra và chuyển đổi thời gian thành UTC nếu cần
    DateTime utcDate = this.isUtc ? this : this.toUtc(); // Kiểm tra xem đối tượng đã là UTC chưa
    return utcDate.millisecondsSinceEpoch;
  }
}

extension DateTimeExtensionsFirstDate on DateTime {
  /// Chuyển đổi DateTime thành milliseconds từ epoch tại đầu ngày (00:00:00 UTC)
  int toEpochMillisecondsAtStartOfDay() {
    DateTime localStartOfDay = DateTime(year, month, day); // Đầu ngày theo local
    return localStartOfDay.toUtc().millisecondsSinceEpoch; // Chuyển sang UTC
  }
}


extension IntergerNumberExtension on int {
  String convertToUTC(String? format) {
    final date = DateTime.fromMillisecondsSinceEpoch(this).toUtc();
    String formattedDate = DateFormat(format, 'vi_VN').format(date);
    return formattedDate;
  }

  String convertToTicketDate(String format) {
    final date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    String formattedDate = DateFormat('EEEE, $format', 'vi_VN').format(date);
    return formattedDate;
  }

  String convertToSectionTicketDate(String format) {
    final date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    String formattedDate = DateFormat('EEEE, $format', 'vi_VN').format(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);
    if (aDate == today) {
      return 'Hôm nay, ' + this.convertToUTC('dd/MM/yyyy');
    } else {
      return formattedDate;
    }
  }

  String toDateString({format = 'HH:mm dd/MM/yyyy'}) {
    var x = DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this, isUtc: false));
    return x;
  }

  String toDateUTCString({format = 'dd/MM/yyyy'}) {
    var x = DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this, isUtc: false));
    return x;
  }

  String toTimeUTCString({format = 'HH:mm:ss'}) {
    var x = DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this, isUtc: false));
    return x;
  }
// String toCurrency({subfix = ' đ'}) {
//   var f = NumberFormat('###,###');
//   return f.format(this) + subfix;
// }
}
//
// extension HexColor on Color {
//   static Color toColor(String hex) {
//     if (hex == null) {
//       return primaryColor;
//     } else {
//       if (hex.length == 7) {
//         return Color(int.parse('0xff${hex.split('#').join()}'));
//       } else {
//         return primaryColor;
//       }
//     }
//   }
//    static Color getFontColorForBackground(Color background) {
//     return (background.computeLuminance() > 0.579)
//         ? Colors.black
//         : Colors.white;
//   }
// }
//
//
// extension DoubleNumberExtension on double {
//   String formatNumber({String separator = '.', String subfix = ''}) {
//     var f = NumberFormat('###'+separator+'###');
//     return f.format(this) + subfix;
//   }
// }

enum PopupInfor {
  notFound,
  wrongMoney,
  needLessMoney,
  finishWork,
  wrongPhoneNumber,
  wrongOTP,
}

enum SingingCharacter { domestic, international }

enum ExpenseCharacter { fixed  ,nonFixed }
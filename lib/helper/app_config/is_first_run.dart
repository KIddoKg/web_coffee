import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _firstRunKey = 'is_first_run';

  // Hàm kiểm tra và lưu trạng thái first run
  static Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool(_firstRunKey) ?? true;

    if (isFirstRun) {
      // Nếu lần đầu, set lại để lần sau biết là đã chạy
      await prefs.setBool(_firstRunKey, false);
    }

    return isFirstRun;
  }

  // Hàm reset trạng thái (nếu cần reset lại)
  static Future<void> resetFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstRunKey, true);
  }
}

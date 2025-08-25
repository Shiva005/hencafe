import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionManager {
  static Future<void> generateNewSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.prefAppSessionID, Uuid().v4());
  }

  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.prefAppSessionID);
  }
}

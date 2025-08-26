import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionManager {
  static Future<void> generateNewSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppStrings.prefAppSessionID, Uuid().v4());
    logger.w(prefs.getString(AppStrings.prefAppSessionID));
  }

  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.prefAppSessionID);
  }
}

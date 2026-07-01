import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveToken(String token) async {
    return await _prefs!.setString(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return _prefs?.getString(AppConstants.tokenKey);
  }

  static Future<bool> saveUserId(String id) async {
    return await _prefs!.setString(AppConstants.userIdKey, id);
  }

  static String? getUserId() {
    return _prefs?.getString(AppConstants.userIdKey);
  }

  static Future<bool> clearData() async {
    return await _prefs!.clear();
  }

  static Future<bool> removeToken() async {
    return await _prefs!.remove(AppConstants.tokenKey);
  }

  static Future<bool> removeUserId() async {
    return await _prefs!.remove(AppConstants.userIdKey);
  }
}

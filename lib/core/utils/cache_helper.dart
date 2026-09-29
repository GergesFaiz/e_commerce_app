import 'package:flutter/material.dart';
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

  /// Profile shown on the Account tab (the API has no "get me" endpoint).
  static Future<void> saveProfile({String? name, String? email, String? phone}) async {
    if (name != null) await _prefs!.setString(AppConstants.userNameKey, name);
    if (email != null) await _prefs!.setString(AppConstants.userEmailKey, email);
    if (phone != null) await _prefs!.setString(AppConstants.userPhoneKey, phone);
  }

  static String get userName => _prefs?.getString(AppConstants.userNameKey) ?? '';
  static String get userEmail => _prefs?.getString(AppConstants.userEmailKey) ?? '';
  static String get userPhone => _prefs?.getString(AppConstants.userPhoneKey) ?? '';

  /// Removes the token and everything tied to the signed-in user.
  static Future<void> clearSession() async {
    for (final key in [
      AppConstants.tokenKey,
      AppConstants.userIdKey,
      AppConstants.userNameKey,
      AppConstants.userEmailKey,
      AppConstants.userPhoneKey,
    ]) {
      await _prefs!.remove(key);
    }
  }

  static Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  @visibleForTesting
  static void setPrefsForTest(SharedPreferences prefs) {
    _prefs = prefs;
  }
}

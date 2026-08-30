// lib/core/services/school_auth_shared_pref_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SchoolAuthSharedPrefService {
  static const String _keyIsLoggedIn = 'school_is_logged_in';
  static const String _keyUserType = 'school_user_type';
  static const String _keyUserId = 'school_user_id';
  static const String _keyUserName = 'school_user_name';

  static Future<void> saveUserData({
    required int userId,
    required String userName,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserType, userType);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType) ?? 'student';
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId) ?? 0;
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserType);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
  }
}
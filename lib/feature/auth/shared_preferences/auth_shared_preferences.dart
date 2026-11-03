import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/model/auth_model.dart';

class AuthSharedPreferences {
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save full user data (id, phone, timestamps, flag)
  static Future<void> saveUserData(UserData user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
      await prefs.setBool(_keyIsLoggedIn, true);
      print('✅ User data saved successfully: ${user.toJson()}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  static Future<UserData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_keyUserData);
      if (jsonData != null) {
        return UserData.fromJson(jsonDecode(jsonData));
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyIsLoggedIn);
      print('✅ User data cleared');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

  static Future<void> updateLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('❌ Error updating login status: $e');
    }
  }
}
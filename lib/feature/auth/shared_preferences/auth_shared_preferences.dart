import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/model/auth_model.dart';

class AuthSharedPreferences {
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Save user data
  static Future<void> saveUserData(UserData user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(user.toJson());
      await prefs.setString(_keyUserData, jsonData);
      await prefs.setBool(_keyIsLoggedIn, true);
      print('✅ User data saved successfully');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // Get user data
  static Future<UserData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_keyUserData);
      if (jsonData != null) {
        final Map<String, dynamic> data = jsonDecode(jsonData);
        return UserData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Clear user data (logout)
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

  // Update user login status
  static Future<void> updateLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('❌ Error updating login status: $e');
    }
  }
}
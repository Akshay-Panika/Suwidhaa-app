import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolAuthSharedPrefService {
  // ============================================================
  // STUDENT KEYS
  // ============================================================
  static const _keyIsLoggedIn       = 'school_is_logged_in';
  static const _keyStudentId        = 'school_student_id';
  static const _keyStudentName      = 'school_student_name';
  static const _keyStudentClass     = 'school_student_class';
  static const _keyStudentIdCard    = 'school_student_id_card';
  static const _keyLastLogin        = 'school_last_login';
  static const _keyRawJson          = 'school_auth_raw_json';
  static const _keyStudentSchoolJson = 'school_student_school_json'; // ✅ NEW

  // ============================================================
  // TEACHER KEYS
  // ============================================================
  static const _keyUserType         = 'school_user_type';
  static const _keyTeacherId        = 'school_teacher_id';
  static const _keyTeacherName      = 'school_teacher_name';
  static const _keyTeacherClass     = 'school_teacher_class';
  static const _keyTeacherIdCard    = 'school_teacher_id_card';
  static const _keyTeacherLastLogin = 'school_teacher_last_login';
  static const _keyTeacherRawJson   = 'school_teacher_raw_json';
  static const _keyTeacherSchoolJson = 'school_teacher_school_json'; // ✅ NEW

  // ============================================================
  // SAVE — STUDENT
  // ============================================================
  static Future<void> saveStudentLogin(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserType, 'student');
    await prefs.setInt(_keyStudentId, (data['student'] ?? 0) as int);
    await prefs.setString(_keyStudentName, data['student_name'] ?? '');
    await prefs.setString(_keyStudentClass, data['student_class'] ?? '');
    await prefs.setString(_keyStudentIdCard, data['student_id_card'] ?? '');
    await prefs.setString(_keyLastLogin, data['last_login'] ?? '');
    await prefs.setString(_keyRawJson, jsonEncode(data));

    // ✅ Save Nested School Object
    if (data['school'] != null) {
      await prefs.setString(_keyStudentSchoolJson, jsonEncode(data['school']));
    } else {
      await prefs.remove(_keyStudentSchoolJson);
    }
  }

  // ============================================================
  // SAVE — TEACHER
  // ============================================================
  static Future<void> saveTeacherLogin(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserType, 'teacher');
    await prefs.setInt(_keyTeacherId, (data['teacher'] ?? 0) as int);
    await prefs.setString(_keyTeacherName, data['teacher_name'] ?? '');
    await prefs.setString(_keyTeacherClass, data['teacher_class'] ?? '');
    await prefs.setString(_keyTeacherIdCard, data['teacher_id_card'] ?? '');
    await prefs.setString(_keyTeacherLastLogin, data['last_login'] ?? '');
    await prefs.setString(_keyTeacherRawJson, jsonEncode(data));

    // ✅ Save Nested School Object
    if (data['school'] != null) {
      await prefs.setString(_keyTeacherSchoolJson, jsonEncode(data['school']));
    } else {
      await prefs.remove(_keyTeacherSchoolJson);
    }
  }

  // ============================================================
  // SHARED
  // ============================================================
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  static Future<bool> isStudentLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_keyIsLoggedIn) ?? false) &&
        (prefs.getString(_keyUserType) == 'student');
  }

  static Future<bool> isTeacherLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_keyIsLoggedIn) ?? false) &&
        (prefs.getString(_keyUserType) == 'teacher');
  }

  // ============================================================
  // STUDENT READ
  // ============================================================
  static Future<int?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStudentId);
  }

  static Future<String?> getStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStudentName);
  }

  static Future<String?> getStudentClass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStudentClass);
  }

  static Future<String?> getStudentIdCard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStudentIdCard);
  }

  static Future<String?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastLogin);
  }

  static Future<Map<String, dynamic>?> getStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyRawJson);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ✅ NEW: Get Student's School Data
  static Future<Map<String, dynamic>?> getStudentSchoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyStudentSchoolJson);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // TEACHER READ
  // ============================================================
  static Future<int?> getTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTeacherId);
  }

  static Future<String?> getTeacherName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTeacherName);
  }

  static Future<String?> getTeacherClass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTeacherClass);
  }

  static Future<String?> getTeacherIdCard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTeacherIdCard);
  }

  static Future<String?> getTeacherLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTeacherLastLogin);
  }

  static Future<Map<String, dynamic>?> getTeacherStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTeacherRawJson);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ✅ NEW: Get Teacher's School Data
  static Future<Map<String, dynamic>?> getTeacherSchoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTeacherSchoolJson);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // CLEAR — STUDENT
  // ============================================================
  static Future<void> clearStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyStudentId);
    await prefs.remove(_keyStudentName);
    await prefs.remove(_keyStudentClass);
    await prefs.remove(_keyStudentIdCard);
    await prefs.remove(_keyLastLogin);
    await prefs.remove(_keyRawJson);
    await prefs.remove(_keyStudentSchoolJson); // ✅ Remove school
    if (prefs.getString(_keyUserType) == 'student') {
      await prefs.remove(_keyUserType);
    }
  }

  // ============================================================
  // CLEAR — TEACHER
  // ============================================================
  static Future<void> clearTeacher() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTeacherId);
    await prefs.remove(_keyTeacherName);
    await prefs.remove(_keyTeacherClass);
    await prefs.remove(_keyTeacherIdCard);
    await prefs.remove(_keyTeacherLastLogin);
    await prefs.remove(_keyTeacherRawJson);
    await prefs.remove(_keyTeacherSchoolJson); // ✅ Remove school
    if (prefs.getString(_keyUserType) == 'teacher') {
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserType);
    }
  }

  // ============================================================
  // CLEAR — EVERYTHING
  // ============================================================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserType);

    // Student
    await prefs.remove(_keyStudentId);
    await prefs.remove(_keyStudentName);
    await prefs.remove(_keyStudentClass);
    await prefs.remove(_keyStudentIdCard);
    await prefs.remove(_keyLastLogin);
    await prefs.remove(_keyRawJson);
    await prefs.remove(_keyStudentSchoolJson);

    // Teacher
    await prefs.remove(_keyTeacherId);
    await prefs.remove(_keyTeacherName);
    await prefs.remove(_keyTeacherClass);
    await prefs.remove(_keyTeacherIdCard);
    await prefs.remove(_keyTeacherLastLogin);
    await prefs.remove(_keyTeacherRawJson);
    await prefs.remove(_keyTeacherSchoolJson);
  }
}


class OldSchoolAuthSharedPrefService {
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
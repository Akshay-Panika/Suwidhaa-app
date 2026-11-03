import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';

class TeacherAuthRepository {
  final Dio _dio = ApiClient.dio;

  /// POST /teacher-pass/login/
  Future<Map<String, dynamic>> login({
    required String teacherIdCard,
    required String password,
  }) async {
    final res = await _dio.post(
      ApiUrls.teacherPassLogin,
      data: {
        'teacher_id_card': teacherIdCard,
        'password': password,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /teacher-pass/forgot-password/request-otp/
  Future<Map<String, dynamic>> requestOtp({
    required String teacherIdCard,
    required String dob, // YYYY-MM-DD
  }) async {
    final res = await _dio.post(
      ApiUrls.teacherPassRequestOtp,
      data: {
        'teacher_id_card': teacherIdCard,
        'dob': dob,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /teacher-pass/forgot-password/verify-and-reset/
  Future<Map<String, dynamic>> verifyOtpAndReset({
    required String teacherIdCard,
    required String otp,
    required String newPassword,
  }) async {
    final res = await _dio.post(
      ApiUrls.teacherPassVerifyAndReset,
      data: {
        'teacher_id_card': teacherIdCard,
        'otp': otp,
        'new_password': newPassword,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /teacher-pass/logout/
  Future<Map<String, dynamic>> logout({
    required String teacherIdCard,
  }) async {
    final res = await _dio.post(
      ApiUrls.teacherPassLogout,
      data: {'teacher_id_card': teacherIdCard},
    );
    return Map<String, dynamic>.from(res.data);
  }
}
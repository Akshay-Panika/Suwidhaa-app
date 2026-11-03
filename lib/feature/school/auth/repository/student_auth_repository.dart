import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';

class StudentAuthRepository {
  final Dio _dio = ApiClient.dio;

  /// POST /student-pass/login/
  Future<Map<String, dynamic>> login({
    required String studentIdCard,
    required String password,
  }) async {
    final res = await _dio.post(
      ApiUrls.studentPassLogin,
      data: {
        'student_id_card': studentIdCard,
        'password': password,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /student-pass/forgot-password/request-otp/
  Future<Map<String, dynamic>> requestOtp({
    required String studentIdCard,
    required String dob, // format: YYYY-MM-DD
  }) async {
    final res = await _dio.post(
      ApiUrls.studentPassRequestOtp,
      data: {
        'student_id_card': studentIdCard,
        'dob': dob,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /student-pass/forgot-password/verify-and-reset/
  Future<Map<String, dynamic>> verifyOtpAndReset({
    required String studentIdCard,
    required String otp,
    required String newPassword,
  }) async {
    final res = await _dio.post(
      ApiUrls.studentPassVerifyAndReset,
      data: {
        'student_id_card': studentIdCard,
        'otp': otp,
        'new_password': newPassword,
      },
    );
    return Map<String, dynamic>.from(res.data);
  }

  /// POST /student-pass/logout/
  Future<Map<String, dynamic>> logout({
    required String studentIdCard,
  }) async {
    final res = await _dio.post(
      ApiUrls.studentPassLogout,
      data: {'student_id_card': studentIdCard},
    );
    return Map<String, dynamic>.from(res.data);
  }
}
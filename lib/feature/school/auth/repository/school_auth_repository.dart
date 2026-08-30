// lib/feature/auth/repository/school_auth_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/school_auth_model.dart';
import '../service/school_auth_shared_pref_service.dart';

class SchoolAuthRepository {
  final Dio _dio = ApiClient.dio;

  Future<SchoolAuthLoginResponse> studentLogin(SchoolAuthLoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiUrls.studentLogin,
        data: request.toJson(),
      );

      final loginResponse = SchoolAuthLoginResponse.fromJson(response.data);

      if (loginResponse.success && loginResponse.data != null) {
        await SchoolAuthSharedPrefService.saveUserData(
          userId: loginResponse.data!.student,
          userName: loginResponse.data!.studentName,
          userType: 'student',
        );
      }

      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          return SchoolAuthLoginResponse(
            success: false,
            message: errorData['message'] ?? 'Login failed',
          );
        } catch (_) {
          return SchoolAuthLoginResponse(
            success: false,
            message: 'Network error: ${e.message}',
          );
        }
      }
      return SchoolAuthLoginResponse(
        success: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return SchoolAuthLoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<SchoolAuthLoginResponse> teacherLogin(SchoolAuthTeacherLoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiUrls.teacherLogin,
        data: request.toJson(),
      );

      final loginResponse = SchoolAuthLoginResponse.fromJson(response.data);

      if (loginResponse.success && loginResponse.data != null) {
        await SchoolAuthSharedPrefService.saveUserData(
          userId: loginResponse.data!.teacher,
          userName: loginResponse.data!.teacherName,
          userType: 'teacher',
        );
      }

      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          return SchoolAuthLoginResponse(
            success: false,
            message: errorData['message'] ?? 'Login failed',
          );
        } catch (_) {
          return SchoolAuthLoginResponse(
            success: false,
            message: 'Network error: ${e.message}',
          );
        }
      }
      return SchoolAuthLoginResponse(
        success: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return SchoolAuthLoginResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<bool> isLoggedIn() async {
    return await SchoolAuthSharedPrefService.isLoggedIn();
  }

  Future<String> getUserType() async {
    return await SchoolAuthSharedPrefService.getUserType();
  }

  Future<int> getUserId() async {
    return await SchoolAuthSharedPrefService.getUserId();
  }

  Future<String> getUserName() async {
    return await SchoolAuthSharedPrefService.getUserName();
  }

  Future<void> logout() async {
    await SchoolAuthSharedPrefService.clearUserData();
  }
}
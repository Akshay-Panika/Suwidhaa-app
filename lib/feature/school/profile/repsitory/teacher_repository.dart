// lib/feature/school/teacher/repository/teacher_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/teacher_model.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';

class TeacherRepository {
  final Dio _dio = ApiClient.dio;

  Future<TeacherResponse> getTeacherProfile(int teacherId) async {
    try {
      final response = await _dio.get(
        '${ApiUrls.teacherDetail}$teacherId/',
      );

      return TeacherResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          throw Exception(errorData['message'] ?? 'Failed to load teacher profile');
        } catch (_) {
          throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load teacher profile: $e');
    }
  }

  // Method to get teacher ID from shared preferences
  Future<int> getTeacherId() async {
    return await SchoolAuthSharedPrefService.getUserId();
  }

  // Method to get teacher name from shared preferences
  Future<String> getTeacherName() async {
    return await SchoolAuthSharedPrefService.getUserName();
  }
}
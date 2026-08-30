// lib/feature/school/student/repository/student_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/student_model.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';

class StudentRepository {
  final Dio _dio = ApiClient.dio;

  Future<StudentResponse> getStudentProfile(int studentId) async {
    try {
      final response = await _dio.get(
        '${ApiUrls.studentDetail}$studentId/',
      );

      return StudentResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          throw Exception(errorData['message'] ?? 'Failed to load student profile');
        } catch (_) {
          throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load student profile: $e');
    }
  }

  // Method to get student ID from shared preferences
  Future<int> getStudentId() async {
    return await SchoolAuthSharedPrefService.getUserId();
  }

  // Method to get student name from shared preferences
  Future<String> getStudentName() async {
    return await SchoolAuthSharedPrefService.getUserName();
  }
}
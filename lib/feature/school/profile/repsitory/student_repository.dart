// lib/feature/school/student/repository/student_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/student_model.dart';

class StudentRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /student/<id>/
  Future<StudentResponse> getStudentProfile(int studentId) async {
    try {
      final response = await _dio.get('${ApiUrls.studentDetail}$studentId/');
      return StudentResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final errorData = Map<String, dynamic>.from(e.response!.data);
        throw Exception(
          errorData['message'] ?? 'Failed to load student profile',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load student profile: $e');
    }
  }

  /// Student ID from SharedPreferences (set during login)
  Future<int> getStudentId() async {
    final id = await SchoolAuthSharedPrefService.getStudentId();
    return id ?? 0;
  }
}
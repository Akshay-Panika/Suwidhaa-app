// lib/feature/school/student_list/repository/student_list_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/student_list_model.dart';

class StudentListRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /student/list/school/<school_id>/
  Future<StudentListResponse> getStudentList() async {
    try {
      final userType = await SchoolAuthSharedPrefService.getUserType();
      int? schoolId;

      if (userType == 'teacher') {
        final schoolData = await SchoolAuthSharedPrefService.getTeacherSchoolData();
        schoolId = schoolData?['id'] as int?;
      } else {
        final schoolData = await SchoolAuthSharedPrefService.getStudentSchoolData();
        schoolId = schoolData?['id'] as int?;
      }

      if (schoolId == null || schoolId == 0) {
        throw Exception('School ID not found. Please login again.');
      }

      // 2. API Call
      final response = await _dio.get(
        ApiUrls.studentListBySchoolId(schoolId),
      );

      return StudentListResponse.fromJson(response.data);

    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          throw Exception(errorData['message'] ?? 'Failed to load student list');
        } catch (_) {
          throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load student list: $e');
    }
  }
}
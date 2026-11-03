// lib/feature/school/teacher/repository/teacher_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/teacher_model.dart';

class TeacherRepository {
  final Dio _dio = ApiClient.dio;

  // ==================== SINGLE TEACHER PROFILE ====================
  Future<TeacherResponse> getTeacherProfile(int teacherId) async {
    try {
      final response = await _dio.get('${ApiUrls.teacherDetail}$teacherId/');
      return TeacherResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response?.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to load teacher profile');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load teacher profile: $e');
    }
  }

  // ==================== TEACHER LIST ====================
  Future<TeacherListResponse> getTeacherList({String? schoolType}) async {
    try {
      final response = await _dio.get(
        ApiUrls.teacherList,
        queryParameters: {
          if (schoolType != null && schoolType.isNotEmpty)
            'school_type': schoolType,
        },
      );
      return TeacherListResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response?.data as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to load teacher list');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load teacher list: $e');
    }
  }

  // ✅ Naye SharedPref se ID uthayega
  Future<int> getTeacherId() async {
    final id = await SchoolAuthSharedPrefService.getTeacherId();
    return id ?? 0;
  }
}
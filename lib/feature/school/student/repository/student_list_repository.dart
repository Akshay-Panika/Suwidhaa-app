// lib/feature/school/student_list/repository/student_list_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/student_list_model.dart';

class StudentListRepository {
  final Dio _dio = ApiClient.dio;

  Future<StudentListResponse> getStudentList() async {
    try {
      final response = await _dio.get(
        ApiUrls.studentList,
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
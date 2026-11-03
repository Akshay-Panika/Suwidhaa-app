// lib/feature/school/attendance/repository/student_attendance_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/student_attendance_model.dart';

class StudentAttendanceRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /student-attendance/list/<student_id>/
  Future<StudentAttendanceIdwiseModel> getStudentAttendanceById({int? studentId}) async {
    try {
      // Agar id pass nahi hui, to SharedPref se uthao (for logged in student)
      final id = studentId ?? await SchoolAuthSharedPrefService.getStudentId();

      if (id == null || id == 0) {
        throw Exception('Student ID not found. Please login again.');
      }

      final response = await _dio.get(ApiUrls.studentAttendanceDetail(id));

      return StudentAttendanceIdwiseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final errorData = Map<String, dynamic>.from(e.response!.data);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Failed to load attendance');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load attendance: $e');
    }
  }

  /// GET /student-attendance/today/<student_id>/
  Future<TodayAttendanceModel> getTodayAttendance(int studentId) async {
    try {
      final response = await _dio.get(ApiUrls.studentAttendanceToday(studentId));

      return TodayAttendanceModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final errorData = Map<String, dynamic>.from(e.response!.data);
        throw Exception(errorData['message'] ?? errorData['error'] ?? 'Failed to load today attendance');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load today attendance: $e');
    }
  }

  /// POST /student-attendance/create/
  Future<StudentAttendanceCreateResponse> createBulkAttendance(
      List<StudentAttendanceItem> items,
      ) async {
    try {
      final response = await _dio.post(
        ApiUrls.studentAttendanceCreate,
        data: {
          "students": items.map((e) => e.toJson()).toList(),
        },
      );

      return StudentAttendanceCreateResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final errorData = Map<String, dynamic>.from(e.response!.data);
        throw Exception(errorData['message'] ?? 'Failed to save attendance');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to save attendance: $e');
    }
  }
}
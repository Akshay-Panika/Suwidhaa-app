// lib/repository/student_attendance_repository.dart
import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';

import '../../../../core/network/api_client.dart';
import '../model/student_attendance_model.dart';

class StudentAttendanceRepository {
  final Dio _dio = ApiClient.dio;

  // ✅ existing — वैसा ही रहेगा
  Future<StudentAttendanceIdwiseModel> getStudentAttendanceById(
      String studentCardId) async {
    try {
      final response = await _dio.get(
        '${ApiUrls.studentAttendanceDetail}$studentCardId/',
      );

      if (response.statusCode == 200) {
        return StudentAttendanceIdwiseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load attendance: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Something went wrong!',
      );
    }
  }

  // ✅ NEW — bulk create / update attendance
  Future<StudentAttendanceCreateResponse> createBulkAttendance(
      List<StudentAttendanceItem> items) async {
    try {
      final body = StudentAttendanceCreateRequest(students: items).toJson();

      final response = await _dio.post(
        ApiUrls.studentAttendanceCreate,
        data: body,
      );

      if (response.statusCode == 200) {
        return StudentAttendanceCreateResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to save attendance: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Something went wrong!',
      );
    }
  }
}
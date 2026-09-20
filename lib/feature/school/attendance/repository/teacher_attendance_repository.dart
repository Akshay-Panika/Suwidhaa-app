// lib/feature/school/attendance/repository/teacher_attendance_repository.dart

import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../model/teacher_attendance_model.dart';

class TeacherAttendanceRepository {
  final Dio _dio = ApiClient.dio;

  Future<TeacherAttendanceModel> getTeacherAttendance({
    required String teacherId,
  }) async {
    try {
      final response = await _dio.get(
        ApiUrls.teacherAttendanceHistory,
        queryParameters: {
          'teacher_id': teacherId,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return TeacherAttendanceModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load attendance: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Something went wrong while fetching attendance',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
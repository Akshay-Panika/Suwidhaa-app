// lib/feature/school/attendance/repository/teacher_checkin_checkout_repository.dart

import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_client.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../model/teacher_checkin_checkout_model.dart';

class TeacherCheckInOutRepository {
  final Dio _dio = ApiClient.dio;

  /// ✅ POST — Check In
  Future<TeacherCheckInOutModel> checkIn({
    required String teacherId,
    String remarks = 'self',
  }) async {
    try {
      final response = await _dio.post(
        ApiUrls.teacherAttendanceCheckIn,
        data: FormData.fromMap({
          'teacher_id': teacherId,
          'remarks': remarks,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TeacherCheckInOutModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Check-in failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Check-in failed',
      );
    }
  }

  /// ✅ POST — Check Out
  Future<TeacherCheckInOutModel> checkOut({
    required String teacherId,
    String remarks = 'self',
  }) async {
    try {
      final response = await _dio.post(
        ApiUrls.teacherAttendanceCheckOut,
        data: FormData.fromMap({
          'teacher_id': teacherId,
          'remarks': remarks,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TeacherCheckInOutModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Check-out failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Check-out failed',
      );
    }
  }

  /// ✅ GET — Today's attendance
  Future<TeacherCheckInOutModel> getToday({required String teacherId}) async {
    try {
      final response = await _dio.get(
        ApiUrls.teacherAttendanceToday,
        queryParameters: {'teacher_id': teacherId},
      );

      if (response.statusCode == 200) {
        return TeacherCheckInOutModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load today: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to load today',
      );
    }
  }
}
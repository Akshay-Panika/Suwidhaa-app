// lib/feature/school/student_leave/repository/student_leave_repository.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/student_leave_list_model.dart';

class StudentLeaveRepository {
  final Dio _dio = ApiClient.dio;

  // ==================== GET LIST ====================
  Future<StudentLeaveListModel> getStudentLeaveList() async {
    try {
      final response = await _dio.get(ApiUrls.studentLeaveList);
      if (response.statusCode == 200) {
        return StudentLeaveListModel.fromJson(response.data);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  // ==================== PATCH APPROVAL ====================
  Future<StudentLeaveApprovalResponse> updateLeaveApproval({
    required int leaveId,
    required String status,
    String? teacherCardId,
    String? teacherName,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiUrls.studentLeaveApproval}$leaveId/',
        data: {
          'leave_status': status.toLowerCase(),
          if (teacherCardId != null) 'teacher_card_id': teacherCardId,
          if (teacherName != null) 'teacher_name': teacherName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StudentLeaveApprovalResponse.fromJson(response.data);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  // ==================== ERROR HANDLER ====================
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) return data['message'];
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
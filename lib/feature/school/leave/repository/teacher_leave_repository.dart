// lib/feature/school/leave/repository/teacher_leave_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/teacher_leave_model.dart';

class TeacherLeaveRepository {
  final Dio _dio = ApiClient.dio;

  // ══════════════════════════════════════════════════════
  // CREATE — apply_status is a string now
  // ══════════════════════════════════════════════════════
  Future<Map<String, dynamic>> createLeave({
    required String teacherId,
    required String teacherIdCard,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String applyStatus = 'pending', // ✅ default = pending
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'teacher_id': teacherId,
      'teacher_id_card': teacherIdCard,
      'apply_status': applyStatus,
      'reason_msg': reasonMsg,
      'start_date': startDate,
      'end_date': endDate,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    final response = await _dio.post(
      ApiUrls.teacherLeaveCreate,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  // ══════════════════════════════════════════════════════
  // ✅ NEW: UPDATE ONLY STATUS
  //   PATCH /teacher-leave/<id>/status/
  //   status: 'pending' | 'approved' | 'rejected'
  // ══════════════════════════════════════════════════════
  Future<Map<String, dynamic>> updateLeaveStatus({
    required int id,
    required String status,
  }) async {
    try {
      final response = await _dio.patch(
        ApiUrls.teacherLeaveStatusUpdate(id),
        data: {'apply_status': status},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['message'] ?? e.message)
          : e.message;
      throw Exception('Status update failed: $msg');
    }
  }

  // ══════════════════════════════════════════════════════
  // LIST ALL
  // ══════════════════════════════════════════════════════
  Future<List<TeacherLeaveModel>> getAllLeaves() async {
    final response = await _dio.get(ApiUrls.teacherLeaveList);
    final data = response.data;
    if (data['status'] == true) {
      return (data['data'] as List)
          .map((e) =>
          TeacherLeaveModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  // ══════════════════════════════════════════════════════
  // TEACHER-WISE (DB int id)
  // ══════════════════════════════════════════════════════
  Future<List<TeacherLeaveModel>> getLeavesByTeacherId(int teacherId) async {
    try {
      final response =
      await _dio.get(ApiUrls.teacherLeaveByTeacherId(teacherId));
      final data = response.data;
      if (data['status'] == true) {
        return (data['data'] as List)
            .map((e) =>
            TeacherLeaveModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════
  // SCHOOL-WISE
  // ══════════════════════════════════════════════════════
  Future<List<TeacherLeaveModel>> getLeavesBySchool(int schoolId) async {
    try {
      final response =
      await _dio.get(ApiUrls.teacherLeaveBySchool(schoolId));
      final data = response.data;
      if (data['status'] == true) {
        return (data['data'] as List)
            .map((e) =>
            TeacherLeaveModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════
  // BY ID CARD
  // ══════════════════════════════════════════════════════
  Future<List<TeacherLeaveModel>> getLeavesByTeacherIdCard(
      String teacherIdCard) async {
    try {
      final card = Uri.encodeComponent(teacherIdCard.trim());
      final response =
      await _dio.get('${ApiUrls.teacherLeaveByIdCard}$card/');
      final data = response.data;
      if (data['status'] == true) {
        return (data['data'] as List)
            .map((e) =>
            TeacherLeaveModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════
  // BY ID
  // ══════════════════════════════════════════════════════
  Future<TeacherLeaveModel?> getLeaveById(int id) async {
    final response = await _dio.get('${ApiUrls.teacherLeaveDetail}$id/');
    final data = response.data;
    if (data['status'] == true) {
      return TeacherLeaveModel.fromJson(
          Map<String, dynamic>.from(data['data']));
    }
    return null;
  }

  // ══════════════════════════════════════════════════════
  // ✅ UPDATE (PATCH — partial)
  // ══════════════════════════════════════════════════════
  Future<Map<String, dynamic>> updateLeave({
    required int id,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'reason_msg': reasonMsg,
      'start_date': startDate,
      'end_date': endDate,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    final response = await _dio.patch(
      '${ApiUrls.teacherLeaveDetail}$id/',
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  // ══════════════════════════════════════════════════════
  // DELETE
  // ══════════════════════════════════════════════════════
  Future<Map<String, dynamic>> deleteLeave(int id) async {
    final response = await _dio.delete(
      '${ApiUrls.teacherLeaveDetail}$id/',
    );
    return response.data as Map<String, dynamic>;
  }
}
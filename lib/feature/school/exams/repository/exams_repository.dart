// lib/feature/school/exams/repository/exams_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/exams_table_model.dart';

class ExamsRepository {
  final Dio _dio = ApiClient.dio;

  // ==================== LIST ====================
  /// GET /api/v1/school/exam-timetables/list/
  /// Optional filters: class_name, exam_type
  Future<List<ClassExamTimetable>> getTimetables({
    String? className,
    String? examType,
  }) async {
    final queryParams = <String, dynamic>{};
    if (className != null && className.isNotEmpty) {
      queryParams['class_name'] = className;
    }
    if (examType != null && examType.isNotEmpty) {
      queryParams['exam_type'] = examType;
    }

    final response = await _dio.get(
      ApiUrls.examTimetableList,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      final list = (data['data'] as List<dynamic>? ?? [])
          .map((e) => ClassExamTimetable.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    }
    throw Exception(data['message'] ?? 'Failed to load timetables');
  }

  // ==================== DETAIL ====================
  /// GET /api/v1/school/exam-timetables/<id>/
  Future<ClassExamTimetable> getTimetableDetail(dynamic id) async {
    final response = await _dio.get(ApiUrls.examTimetableDetail(id is int ? id : int.parse(id.toString())));

    final data = response.data;
    if (data is Map && data['success'] == true) {
      return ClassExamTimetable.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    }
    throw Exception(data['message'] ?? 'Failed to load timetable');
  }

  // ==================== CREATE ====================
  /// POST /api/v1/school/exam-timetables/create/
  Future<ClassExamTimetable> createTimetable({
    required ClassExamTimetable timetable,
    String? createdById,
    String? createdByName,
  }) async {
    final body = timetable.toJson();
    if (createdById != null) body['created_by_id'] = createdById;
    if (createdByName != null && createdByName.isNotEmpty) {
      body['created_by_name'] = createdByName;
    }

    final response = await _dio.post(
      ApiUrls.examTimetableCreate,
      data: body,
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      return ClassExamTimetable.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    }
    throw Exception(_extractError(data) ?? 'Failed to create timetable');
  }

  // ==================== UPDATE ====================
  /// PUT /api/v1/school/exam-timetables/<id>/
  Future<ClassExamTimetable> updateTimetable({
    required dynamic id,
    required ClassExamTimetable timetable,
  }) async {
    final body = timetable.toJson();
    // removed on backend — safe to omit
    body.remove('created_by_id');
    body.remove('created_by_name');

    final response = await _dio.put(
      ApiUrls.examTimetableDetail(id is int ? id : int.parse(id.toString())),
      data: body,
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      return ClassExamTimetable.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    }
    throw Exception(_extractError(data) ?? 'Failed to update timetable');
  }

  // ==================== DELETE ====================
  /// DELETE /api/v1/school/exam-timetables/<id>/
  Future<void> deleteTimetable(dynamic id) async {
    final response = await _dio.delete(
      ApiUrls.examTimetableDetail(id is int ? id : int.parse(id.toString())),
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      return;
    }
    throw Exception(_extractError(data) ?? 'Failed to delete timetable');
  }

  // ==================== ERROR EXTRACTION ====================
  String? _extractError(dynamic data) {
    if (data is Map) {
      // top-level message
      if (data['message'] != null) return data['message'].toString();

      // DRF validation errors
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is Map) {
          for (final entry in errors.entries) {
            final v = entry.value;
            if (v is List && v.isNotEmpty) {
              return '${entry.key}: ${v.first}';
            }
            return '${entry.key}: $v';
          }
        }
        return errors.toString();
      }
    }
    return null;
  }
}
// lib/feature/school/exams/repository/exams_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/exams_table_model.dart';

class ExamsRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // SCHOOL ID RESOLVER (teacher → teacher, student → student)
  // ============================================================
  Future<int> _activeSchoolIdOrThrow() async {
    if (await SchoolAuthSharedPrefService.isTeacherLoggedIn()) {
      final school = await SchoolAuthSharedPrefService.getTeacherSchoolData();
      final id = _extractSchoolId(school);
      if (id != null && id > 0) return id;
    }
    if (await SchoolAuthSharedPrefService.isStudentLoggedIn()) {
      final school = await SchoolAuthSharedPrefService.getStudentSchoolData();
      final id = _extractSchoolId(school);
      if (id != null && id > 0) return id;
    }
    throw Exception('School not found. Please log in again.');
  }

  int? _extractSchoolId(Map<String, dynamic>? data) {
    if (data == null) return null;
    final raw = data['id'] ?? data['school_id'] ?? data['schoolId'];
    if (raw == null) return null;
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  // ==================== LIST ====================
  /// GET /v1/school/<school_id>/exam-timetables/list/
  Future<List<ClassExamTimetable>> getTimetables({
    String? className,
    String? examType,
  }) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();

      final queryParams = <String, dynamic>{};
      if (className != null && className.isNotEmpty) {
        queryParams['class_name'] = className;
      }
      if (examType != null && examType.isNotEmpty) {
        queryParams['exam_type'] = examType;
      }

      final response = await _dio.get(
        ApiUrls.examTimetableList(schoolId),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      if (data is Map && data['success'] == true) {
        return (data['data'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(ClassExamTimetable.fromJson)
            .toList();
      }
      throw Exception(data['message'] ?? 'Failed to load timetables');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(_extractDioError(e));
    }
  }

  // ==================== DETAIL ====================
  /// GET /v1/school/<school_id>/exam-timetables/<id>/
  Future<ClassExamTimetable> getTimetableDetail(dynamic id) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final response = await _dio.get(
        ApiUrls.examTimetableDetail(schoolId, _asInt(id)),
      );
      final data = response.data;
      if (data is Map && data['success'] == true) {
        return ClassExamTimetable.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw Exception(data['message'] ?? 'Failed to load timetable');
    } on DioException catch (e) {
      throw Exception(_extractDioError(e));
    }
  }

  // ==================== CREATE ====================
  /// POST /v1/school/<school_id>/exam-timetables/create/
  Future<ClassExamTimetable> createTimetable({
    required ClassExamTimetable timetable,
    String? createdById,
    String? createdByName,
  }) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();

      final body = timetable.toJson();
      if (createdById != null) body['created_by_id'] = createdById;
      if (createdByName != null && createdByName.isNotEmpty) {
        body['created_by_name'] = createdByName;
      }

      final response = await _dio.post(
        ApiUrls.examTimetableCreate(schoolId),
        data: body,
      );

      final data = response.data;
      if (data is Map && data['success'] == true) {
        return ClassExamTimetable.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw Exception(_extractError(data) ?? 'Failed to create timetable');
    } on DioException catch (e) {
      throw Exception(_extractDioError(e));
    }
  }

  // ==================== UPDATE ====================
  /// PUT /v1/school/<school_id>/exam-timetables/<id>/
  Future<ClassExamTimetable> updateTimetable({
    required dynamic id,
    required ClassExamTimetable timetable,
  }) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();

      final body = timetable.toJson();
      body.remove('created_by_id');
      body.remove('created_by_name');

      final response = await _dio.put(
        ApiUrls.examTimetableDetail(schoolId, _asInt(id)),
        data: body,
      );

      final data = response.data;
      if (data is Map && data['success'] == true) {
        return ClassExamTimetable.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw Exception(_extractError(data) ?? 'Failed to update timetable');
    } on DioException catch (e) {
      throw Exception(_extractDioError(e));
    }
  }

  // ==================== DELETE ====================
  /// DELETE /v1/school/<school_id>/exam-timetables/<id>/
  Future<void> deleteTimetable(dynamic id) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final response = await _dio.delete(
        ApiUrls.examTimetableDetail(schoolId, _asInt(id)),
      );
      final data = response.data;
      if (data is Map && data['success'] == true) return;
      throw Exception(_extractError(data) ?? 'Failed to delete timetable');
    } on DioException catch (e) {
      throw Exception(_extractDioError(e));
    }
  }

  // ==================== HELPERS ====================
  int _asInt(dynamic v) {
    if (v is int) return v;
    return int.parse(v.toString());
  }

  String _extractDioError(DioException e) {
    final res = e.response?.data;
    if (res is Map) {
      if (res['message'] != null) return res['message'].toString();
      if (res['errors'] != null) {
        final errors = res['errors'];
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
    return e.message ?? 'Something went wrong';
  }

  String? _extractError(dynamic data) {
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
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
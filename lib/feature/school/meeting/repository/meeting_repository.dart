import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/meeting_model.dart';

class MeetingRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // SCHOOL ID RESOLVER (teacher → teacher school, student → student school)
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

  // ============================================================
  // CREATE  →  POST /v1/school/<school_id>/meeting/create/
  // ============================================================
  Future<MeetingModel> createMeeting(Map<String, dynamic> body) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.post(
        ApiUrls.meetingCreate(schoolId),
        data: body,
      );
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception(data['errors'] ?? 'Failed to create meeting');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // LIST  →  GET /v1/school/<school_id>/meeting/list/
  // ============================================================
  Future<List<MeetingModel>> getMeetings({
    String? forMeeting,
    String? className,
    String? date, // yyyy-MM-dd
  }) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.get(
        ApiUrls.meetingList(schoolId),
        queryParameters: {
          if (forMeeting != null && forMeeting.isNotEmpty)
            'for_meeting': forMeeting,
          if (className != null && className.isNotEmpty)
            'class_name': className,
          if (date != null && date.isNotEmpty) 'date': date,
        },
      );
      final data = res.data;
      if (data is Map && data['success'] == true) {
        final list = (data['data'] as List? ?? []);
        return list.map((e) => MeetingModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      // Backend 404 → empty list
      if (e.response?.statusCode == 404) return [];
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // DETAIL  →  GET /v1/school/<school_id>/meeting/<id>/
  // ============================================================
  Future<MeetingModel> getMeetingById(int id) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.get(ApiUrls.meetingDetail(schoolId, id));
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception('Meeting not found');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // UPDATE  →  PUT /v1/school/<school_id>/meeting/<id>/
  // ============================================================
  Future<MeetingModel> updateMeeting(int id, Map<String, dynamic> body) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.put(
        ApiUrls.meetingDetail(schoolId, id),
        data: body,
      );
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception('Failed to update meeting');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // PATCH (partial)  →  PATCH /v1/school/<school_id>/meeting/<id>/
  // ============================================================
  Future<MeetingModel> patchMeeting(
      int id, Map<String, dynamic> body) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.patch(
        ApiUrls.meetingDetail(schoolId, id),
        data: body,
      );
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception('Failed to patch meeting');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // DELETE  →  DELETE /v1/school/<school_id>/meeting/delete/<id>/
  // ============================================================
  Future<bool> deleteMeeting(int id) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final res = await _dio.delete(ApiUrls.meetingDelete(schoolId, id));
      final data = res.data;
      return data is Map && data['success'] == true;
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  // ============================================================
  // Friendly error extractor
  // ============================================================
  String _extractError(DioException e) {
    final res = e.response?.data;
    if (res is Map) {
      if (res['errors'] != null) return res['errors'].toString();
      if (res['detail'] != null) return res['detail'].toString();
      if (res['message'] != null) return res['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
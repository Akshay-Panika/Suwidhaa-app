import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/school_event_model.dart';

class SchoolEventRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // SCHOOL ID RESOLVERS (uses existing SharedPrefService)
  // ============================================================

  /// Teacher's school id (create / update / delete / pin ke liye)
  Future<int> _teacherSchoolIdOrThrow() async {
    final Map<String, dynamic>? school =
    await SchoolAuthSharedPrefService.getTeacherSchoolData();
    final id = _extractSchoolId(school);
    if (id == null || id <= 0) {
      throw Exception('Teacher school not found. Please log in again.');
    }
    return id;
  }

  /// Active school id:
  /// - teacher logged in → teacher ki school id
  /// - student logged in → student ki school id
  Future<int> _activeSchoolIdOrThrow() async {
    if (await SchoolAuthSharedPrefService.isTeacherLoggedIn()) {
      final Map<String, dynamic>? school =
      await SchoolAuthSharedPrefService.getTeacherSchoolData();
      final id = _extractSchoolId(school);
      if (id != null && id > 0) return id;
    }
    if (await SchoolAuthSharedPrefService.isStudentLoggedIn()) {
      final Map<String, dynamic>? school =
      await SchoolAuthSharedPrefService.getStudentSchoolData();
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
  // 1. LIST EVENTS
  //    GET /v1/school/<school_id>/event/list/
  // ============================================================
  Future<List<SchoolEventModel>> getEvents({
    String? category,
    String? audience,
    String? status,
  }) async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();

      final query = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != "All") {
        query['category'] = category;
      }
      if (audience != null && audience.isNotEmpty) {
        query['audience'] = audience;
      }
      if (status != null && status.isNotEmpty && status != "All") {
        query['status'] = status;
      }

      final res = await _dio.get(
        ApiUrls.eventList(schoolId),
        queryParameters: query.isEmpty ? null : query,
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final List data = res.data['data'] ?? [];
        return data.map((e) => SchoolEventModel.fromJson(e)).toList();
      }
      throw Exception(res.data['message'] ?? 'Failed to load events');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 2. CREATE EVENT
  //    POST /v1/school/<school_id>/event/create/
  // ============================================================
  Future<SchoolEventModel> createEvent({
    required String title,
    required String description,
    required String category,
    required String venue,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required String audience,
    required String status,
    required bool isPinned,
    String organizer = 'teacher_101',
    PlatformFile? banner,
  }) async {
    try {
      final schoolId = await _teacherSchoolIdOrThrow();

      final map = <String, dynamic>{
        'title': title,
        'description': description,
        'category': category,
        'venue': venue,
        'start_date': startDate,
        'end_date': endDate,
        'start_time': startTime,
        'end_time': endTime,
        'audience': audience,
        'status': status,
        'is_pinned': isPinned.toString(),
        'organizer': organizer,
      };

      final formData = FormData.fromMap(map);

      if (banner != null && banner.path != null) {
        formData.files.add(MapEntry(
          'banner',
          await MultipartFile.fromFile(
            banner.path!,
            filename: banner.name,
          ),
        ));
      }

      final res = await _dio.post(
        ApiUrls.eventCreate(schoolId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 201 && res.data['success'] == true) {
        return SchoolEventModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to create event');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 3. UPDATE EVENT
  //    PUT /v1/school/<school_id>/event/<id>/
  // ============================================================
  Future<SchoolEventModel> updateEvent({
    required int id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required String audience,
    required String status,
    required bool isPinned,
    String organizer = 'teacher_101',
    PlatformFile? banner,
    bool removeBanner = false,
  }) async {
    try {
      final schoolId = await _teacherSchoolIdOrThrow();

      final map = <String, dynamic>{
        'title': title,
        'description': description,
        'category': category,
        'venue': venue,
        'start_date': startDate,
        'end_date': endDate,
        'start_time': startTime,
        'end_time': endTime,
        'audience': audience,
        'status': status,
        'is_pinned': isPinned.toString(),
        'organizer': organizer,
      };

      if (removeBanner) map['banner'] = null;

      final formData = FormData.fromMap(map);

      if (banner != null && banner.path != null) {
        formData.files.add(MapEntry(
          'banner',
          await MultipartFile.fromFile(
            banner.path!,
            filename: banner.name,
          ),
        ));
      }

      final res = await _dio.put(
        ApiUrls.eventDetail(schoolId, id),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        return SchoolEventModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to update event');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 4. DELETE EVENT
  //    DELETE /v1/school/<school_id>/event/<id>/
  // ============================================================
  Future<void> deleteEvent(int id) async {
    try {
      final schoolId = await _teacherSchoolIdOrThrow();
      final res = await _dio.delete(ApiUrls.eventDetail(schoolId, id));
      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? 'Failed to delete event');
      }
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 5. TOGGLE PIN
  //    POST /v1/school/<school_id>/event/<id>/toggle-pin/
  // ============================================================
  Future<SchoolEventModel> togglePin(int id) async {
    try {
      final schoolId = await _teacherSchoolIdOrThrow();
      final res = await _dio.post(ApiUrls.eventTogglePin(schoolId, id));
      if (res.statusCode == 200 && res.data['success'] == true) {
        return SchoolEventModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to toggle pin');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // Friendly error message
  // ============================================================
  String _dioError(DioException e) {
    if (e.response?.data is Map && e.response!.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
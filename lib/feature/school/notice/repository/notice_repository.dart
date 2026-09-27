import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/notice_model.dart';

class NoticeRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // 1. LIST NOTICES
  //    GET /v1/school/notice/list/
  // ============================================================
  Future<List<NoticeModel>> getNotices({
    String? priority,
    String? audience,
    String? assignedClass,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (priority != null && priority.isNotEmpty) query['priority'] = priority;
      if (audience != null && audience.isNotEmpty) query['audience'] = audience;
      if (assignedClass != null && assignedClass.isNotEmpty) {
        query['class'] = assignedClass;
      }

      final res = await _dio.get(
        ApiUrls.noticeList,
        queryParameters: query.isEmpty ? null : query,
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final List data = res.data['data'] ?? [];
        return data.map((e) => NoticeModel.fromJson(e)).toList();
      }
      throw Exception(res.data['message'] ?? 'Failed to load notices');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 2. CREATE NOTICE (multipart for file upload)
  //    POST /v1/school/notice/create/
  // ============================================================
  Future<NoticeModel> createNotice({
    required String title,
    required String description,
    required String priority,
    required String audience,
    required String assignedClass,
    required bool isPinned,
    String createdBy = 'teacher_101',
    PlatformFile? attachment,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'description': description,
        'priority': priority,
        'audience': audience,
        'assigned_class': assignedClass,
        'is_pinned': isPinned.toString(),
        'created_by': createdBy,
      };

      final formData = FormData.fromMap(map);

      if (attachment != null && attachment.path != null) {
        formData.files.add(
          MapEntry(
            'attachment',
            await MultipartFile.fromFile(
              attachment.path!,
              filename: attachment.name,
            ),
          ),
        );
      }

      final res = await _dio.post(
        ApiUrls.noticeCreate,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 201 && res.data['success'] == true) {
        return NoticeModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to create notice');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 3. UPDATE NOTICE
  //    PUT /v1/school/notice/<id>/
  // ============================================================
  Future<NoticeModel> updateNotice({
    required int id,
    required String title,
    required String description,
    required String priority,
    required String audience,
    required String assignedClass,
    required bool isPinned,
    String createdBy = 'teacher_101',
    PlatformFile? attachment,
    bool removeAttachment = false,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'description': description,
        'priority': priority,
        'audience': audience,
        'assigned_class': assignedClass,
        'is_pinned': isPinned.toString(),
        'created_by': createdBy,
      };

      if (removeAttachment) {
        map['attachment'] = null;
      }

      final formData = FormData.fromMap(map);

      if (attachment != null && attachment.path != null) {
        formData.files.add(
          MapEntry(
            'attachment',
            await MultipartFile.fromFile(
              attachment.path!,
              filename: attachment.name,
            ),
          ),
        );
      }

      final res = await _dio.put(
        ApiUrls.noticeDetail(id),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        return NoticeModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to update notice');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 4. DELETE NOTICE
  //    DELETE /v1/school/notice/<id>/
  // ============================================================
  Future<void> deleteNotice(int id) async {
    try {
      final res = await _dio.delete(ApiUrls.noticeDetail(id));
      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? 'Failed to delete notice');
      }
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // 5. TOGGLE PIN
  //    POST /v1/school/notice/<id>/toggle-pin/
  // ============================================================
  Future<NoticeModel> togglePin(int id) async {
    try {
      final res = await _dio.post(ApiUrls.noticeTogglePin(id));
      if (res.statusCode == 200 && res.data['success'] == true) {
        return NoticeModel.fromJson(res.data['data']);
      }
      throw Exception(res.data['message'] ?? 'Failed to toggle pin');
    } on DioException catch (e) {
      throw Exception(_dioError(e));
    }
  }

  // ============================================================
  // Helper: friendly error message
  // ============================================================
  String _dioError(DioException e) {
    if (e.response?.data is Map && e.response!.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
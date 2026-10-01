import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../model/homework_model.dart';

class HomeworkResponse {
  final bool success;
  final String message;
  final int count;
  final List<HomeworkModel> data;

  HomeworkResponse({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });
}

class HomeworkRepository {
  final Dio _dio = ApiClient.dio;

  Future<HomeworkResponse> getAllHomework() async {
    try {
      final res = await _dio.get('v1/school/homework/list/');
      return _parse(res);
    } on DioException catch (e) {
      throw Exception('Failed to fetch homework: ${e.message}');
    }
  }

  Future<HomeworkResponse> getHomeworkByTeacher(String teacherId) async {
    try {
      final res = await _dio.get(
        'v1/school/homework/list/teacher-id/$teacherId/',
      );
      return _parse(res);
    } on DioException catch (e) {
      throw Exception('Failed to fetch teacher homework: ${e.message}');
    }
  }

  Future<HomeworkResponse> getHomeworkByClass({
    required String schoolType,
    required String className,
  }) async {
    try {
      // URL-encode for safety (class may have spaces like "Class 6")
      final type = Uri.encodeComponent(schoolType.trim());
      final cls = Uri.encodeComponent(className.trim());

      final res = await _dio.get(
        'v1/school/homework/list/$type/$cls/',
      );
      return _parse(res);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to fetch class homework: $msg');
    }
  }

  Future<HomeworkModel?> getHomeworkById(int id) async {
    try {
      final res = await _dio.get('v1/school/homework/$id/');
      final json = res.data as Map<String, dynamic>;
      if (json['success'] == true && json['data'] != null) {
        return HomeworkModel.fromJson(
          Map<String, dynamic>.from(json['data']),
        );
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Failed to fetch homework: ${e.message}');
    }
  }

  // ══════════════════════════════════════════════════════
  // TOGGLE / SET STUDENT STATUS
  // POST /v1/school/homework/<id>/toggle-status/<student_idcard>/
  // ══════════════════════════════════════════════════════
  Future<bool> toggleStudentStatus({
    required int homeworkId,
    required String studentIdcard,
    bool? explicitStatus, // null = toggle, else set explicit value
  }) async {
    try {
      final body = explicitStatus == null
          ? <String, dynamic>{}
          : {"status": explicitStatus};

      final res = await _dio.post(
        'v1/school/homework/$homeworkId/toggle-status/$studentIdcard/',
        data: body,
      );

      return res.data['success'] == true;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('Toggle failed: $msg');
    }
  }
  Future<HomeworkModel> createHomework({
    required String schoolType,
    required String className,
    required String subject,
    required String subjectTopic,
    required String issueDate,
    required String endDate,
    required List<StudentHomeworkEntry> students,
    required String teacherId,
    required String teacherName,
    String? imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        "school_type": schoolType,
        "class_name": className,
        "subject": subject,
        "subject_topic": subjectTopic,
        "issue_date": issueDate,
        "end_date": endDate,
        "student_ids_list": _studentsToJsonString(students),
        "teacher_id": teacherId,
        "teacher_name": teacherName,
        if (imagePath != null)
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final res = await _dio.post(
        'v1/school/homework/create/',
        data: formData,
      );

      final json = res.data as Map<String, dynamic>;
      if (json['success'] == true) {
        return HomeworkModel.fromJson(
          Map<String, dynamic>.from(json['data']),
        );
      }
      throw Exception(json['message'] ?? 'Create failed');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('Create error: $msg');
    }
  }

  // ────────────────────────────────────────────────────────
  // PUT — UPDATE
  // PUT /api/v1/school/homework/<id>/
  // ────────────────────────────────────────────────────────
  Future<HomeworkModel> updateHomework({
    required int id,
    required String schoolType,
    required String className,
    required String subject,
    required String subjectTopic,
    required String issueDate,
    required String endDate,
    required List<StudentHomeworkEntry> students,
    required String teacherId,
    required String teacherName,
    String? imagePath,   // null = keep existing
  }) async {
    try {
      final map = <String, dynamic>{
        "school_type": schoolType,
        "class_name": className,
        "subject": subject,
        "subject_topic": subjectTopic,
        "issue_date": issueDate,
        "end_date": endDate,
        "student_ids_list": _studentsToJsonString(students),
        "teacher_id": teacherId,
        "teacher_name": teacherName,
      };
      if (imagePath != null) {
        map["image"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final res = await _dio.put(
        'v1/school/homework/$id/',
        data: FormData.fromMap(map),
      );

      final json = res.data as Map<String, dynamic>;
      if (json['success'] == true) {
        return HomeworkModel.fromJson(
          Map<String, dynamic>.from(json['data']),
        );
      }
      throw Exception(json['message'] ?? 'Update failed');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('Update error: $msg');
    }
  }

  // ────────────────────────────────────────────────────────
  // DELETE
  // DELETE /api/v1/school/homework/<id>/
  // ────────────────────────────────────────────────────────
  Future<bool> deleteHomework(int id) async {
    try {
      final res = await _dio.delete('v1/school/homework/$id/');
      return res.data['success'] == true;
    } on DioException catch (e) {
      throw Exception('Delete error: ${e.message}');
    }
  }

  // ────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────
  HomeworkResponse _parse(Response res) {
    final json = res.data as Map<String, dynamic>;
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => HomeworkModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return HomeworkResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      count: json['count'] is int ? json['count'] : list.length,
      data: list,
    );
  }

  String _studentsToJsonString(List<StudentHomeworkEntry> students) {
    // Backend expects a JSON array string in multipart form field
    final buf = StringBuffer('[');
    for (int i = 0; i < students.length; i++) {
      if (i > 0) buf.write(',');
      buf.write(
        '{"studentIdcard":"${students[i].studentIdcard}",'
            '"status":${students[i].status}}',
      );
    }
    buf.write(']');
    return buf.toString();
  }
}
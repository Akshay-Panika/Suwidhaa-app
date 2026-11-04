// lib/feature/school/report/repository/report_card_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/report_card_model.dart';

class ReportCardRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /v1/school/report-cards/teacher/{teacher_id_card}/
  Future<ReportCardResponse> getReportCardsByTeacher(String teacherId) async {
    try {
      final url =
          '${ApiUrls.reportCardByTeacherBase}${Uri.encodeComponent(teacherId.trim())}/';
      final res = await _dio.get(url);
      return ReportCardResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ReportCardResponse(
            status: false, message: 'No report cards', count: 0, data: []);
      }
      throw _mapDioError(e, 'Failed to load report cards');
    } catch (e) {
      throw Exception('Failed to load report cards: $e');
    }
  }

  /// GET /v1/school/report-cards/student-list/{student_db_id}/
  Future<ReportCardResponse> getReportCardsByStudentId(
      String studentId) async {
    try {
      final url =
          '${ApiUrls.reportCardByStudentBase}${Uri.encodeComponent(studentId.trim())}/';
      final res = await _dio.get(url);
      return ReportCardResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ReportCardResponse(
            status: false, message: 'No report cards', count: 0, data: []);
      }
      throw _mapDioError(e, 'Failed to load report cards');
    } catch (e) {
      throw Exception('Failed to load report cards: $e');
    }
  }

  /// POST /v1/school/report-cards/create/
  Future<Map<String, dynamic>> createReportCard(
      CreateReportCardRequest body) async {
    try {
      final res = await _dio.post(
        ApiUrls.reportCardCreate,
        data: body.toJson(),
      );
      return (res.data is Map<String, dynamic>)
          ? res.data as Map<String, dynamic>
          : {'status': true, 'data': res.data};
    } on DioException catch (e) {
      throw _mapDioError(e, 'Failed to create report card');
    } catch (e) {
      throw Exception('Failed to create report card: $e');
    }
  }

  /// POST /v1/school/report-cards/bulk-create/  (multi-student, 1 API call)
  Future<BulkCreateResult> bulkCreate({
    required String teacherId,
    required String className,
    required String subjectName,
    required String examName,
    required int totalMarks,
    required int passingMarks,
    required List<CreateReportCardRequest> rows,
  }) async {
    try {
      final res = await _dio.post(
        ApiUrls.reportCardBulkCreate,
        data: {
          'teacher_id': teacherId,
          'class_name': className,
          'subject_name': subjectName,
          'exam_name': examName,
          'sujectmaks_marks': totalMarks,
          'pasingmaks_marks': passingMarks,
          'students': rows.map((r) => r.toBulkRow()).toList(),
        },
      );

      final json = res.data as Map<String, dynamic>;

      final createdIds = <int>[];
      for (final e in (json['created'] as List? ?? [])) {
        if (e is Map && e['id'] is int) createdIds.add(e['id'] as int);
      }

      final failures = <String>[];
      for (final f in (json['failures'] as List? ?? [])) {
        if (f is Map) {
          final sid = f['student_id'] ?? f['index'] ?? '?';
          final err = f['errors'] ?? 'unknown';
          failures.add('Student $sid: $err');
        }
      }

      return BulkCreateResult(created: createdIds, failures: failures);
    } on DioException catch (e) {
      throw _mapDioError(e, 'Bulk create failed');
    } catch (e) {
      throw Exception('Bulk create failed: $e');
    }
  }

  /// PUT /v1/school/report-cards/list/{id}/
  Future<Map<String, dynamic>> updateReportCard(
      int id, CreateReportCardRequest body) async {
    try {
      final url = '${ApiUrls.reportCardDetailBase}$id/';
      final res = await _dio.put(url, data: body.toJson());
      return (res.data is Map<String, dynamic>)
          ? res.data as Map<String, dynamic>
          : {'status': true, 'data': res.data};
    } on DioException catch (e) {
      throw _mapDioError(e, 'Failed to update report card');
    } catch (e) {
      throw Exception('Failed to update report card: $e');
    }
  }

  /// DELETE /v1/school/report-cards/list/{id}/
  Future<bool> deleteReportCard(int id) async {
    try {
      final url = '${ApiUrls.reportCardDetailBase}$id/';
      final res = await _dio.delete(url);
      final data = res.data;
      if (data is Map && data['status'] == false) {
        throw Exception(data['message'] ?? 'Failed to delete report card');
      }
      return true;
    } on DioException catch (e) {
      throw _mapDioError(e, 'Failed to delete report card');
    } catch (e) {
      throw Exception('Failed to delete report card: $e');
    }
  }

  Exception _mapDioError(DioException e, String fallback) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map) {
      final msg = data['message'] ?? data['detail'] ?? data['error'];
      if (msg != null && msg.toString().isNotEmpty) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstField = errors.keys.first;
          final firstErr = errors[firstField];
          final errText = (firstErr is List && firstErr.isNotEmpty)
              ? firstErr.first
              : firstErr;
          return Exception('[$status] $firstField: $errText');
        }
        return Exception('[$status] $msg');
      }
      return Exception('[$status] $data');
    }
    if (data is String && data.isNotEmpty) {
      return Exception('[$status] $data');
    }
    return Exception('[$status] ${e.message ?? fallback}');
  }
}
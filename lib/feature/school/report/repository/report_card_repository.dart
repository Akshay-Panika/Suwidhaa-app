// lib/feature/school/report/repository/report_card_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/report_card_model.dart';

class ReportCardRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /v1/school/report-cards/adminid/{admin_id}/
  Future<ReportCardResponse> getReportCardsByAdmin(String adminId) async {
    try {
      final url = '${ApiUrls.reportCardByAdminBase}$adminId/';
      final response = await _dio.get(url);
      return ReportCardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioError(e, 'Failed to load report cards');
    } catch (e) {
      throw Exception('Failed to load report cards: $e');
    }
  }

  /// POST /v1/school/report-cards/create/
  Future<Map<String, dynamic>> createReportCard(
      CreateReportCardRequest body,
      ) async {
    try {
      final response = await _dio.post(
        ApiUrls.reportCardCreate,
        data: body.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'status': true, 'data': response.data};
    } on DioException catch (e) {
      throw _mapDioError(e, 'Failed to create report card');
    } catch (e) {
      throw Exception('Failed to create report card: $e');
    }
  }

  /// PUT /v1/school/report-cards/list/{id}/
  Future<Map<String, dynamic>> updateReportCard(
      int id,
      CreateReportCardRequest body,
      ) async {
    try {
      final url = '${ApiUrls.reportCardDetailBase}$id/';
      final response = await _dio.put(
        url,
        data: body.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'status': true, 'data': response.data};
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
      final response = await _dio.delete(url);
      final data = response.data;
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

  /// Bulk create — posts one by one.
  Future<BulkCreateResult> createReportCards(
      List<CreateReportCardRequest> requests,
      ) async {
    final created = <int>[];
    final failures = <String>[];

    for (final req in requests) {
      try {
        final res = await createReportCard(req);
        final data = res['data'];
        if (data is Map && data['id'] is int) {
          created.add(data['id'] as int);
        } else if (res['id'] is int) {
          created.add(res['id'] as int);
        } else {
          created.add(-1);
        }
      } catch (e) {
        failures.add('${req.studentId}: $e');
      }
    }
    return BulkCreateResult(created: created, failures: failures);
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
          final errText =
          (firstErr is List && firstErr.isNotEmpty) ? firstErr.first : firstErr;
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

class BulkCreateResult {
  final List<int> created;
  final List<String> failures;

  BulkCreateResult({required this.created, required this.failures});

  bool get hasFailures => failures.isNotEmpty;
}
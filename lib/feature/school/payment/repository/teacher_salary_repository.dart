// lib/feature/school/salary/repository/teacher_salary_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/teacher_salary_model.dart';

class TeacherSalaryRepository {
  final Dio _dio = ApiClient.dio;

  // ══════════════════════════════════════════════════════
  // GET — full transaction history for a teacher
  //   GET /teacher/salary/transaction/history/<teacher_id>/
  // ══════════════════════════════════════════════════════
  Future<SalaryHistoryResponse> getTransactionHistory(
      int teacherId) async {
    try {
      final res = await _dio.get(
        ApiUrls.teacherSalaryTransactionHistory(teacherId),
      );
      return SalaryHistoryResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['message'] ?? e.message)
          : e.message;
      throw Exception('Failed to load salary history: $msg');
    }
  }

  // ══════════════════════════════════════════════════════
  // POST — create transaction
  //   POST /teacher/salary/transaction/create/
  // ══════════════════════════════════════════════════════
  Future<SalaryTransaction> createTransaction({
    required int teacherId,
    required double amountPaid,
    required int month,
    required int year,
    String? remarks,
  }) async {
    try {
      final res = await _dio.post(
        ApiUrls.teacherSalaryTransactionCreate,
        data: {
          'teacher_id': teacherId,
          'amount_paid': amountPaid,
          'month': month,
          'year': year,
          if (remarks != null && remarks.isNotEmpty)
            'remarks': remarks,
        },
      );

      final data = res.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return SalaryTransaction.fromJson(
          Map<String, dynamic>.from(data['data']),
        );
      }
      throw Exception(data['message'] ?? 'Failed to create transaction');
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['errors'] ?? data['message'] ?? e.message)
          : e.message;
      throw Exception('Create failed: $msg');
    }
  }

  // ══════════════════════════════════════════════════════
  // PATCH — update transaction
  //   PATCH /teacher/salary/transaction/<teacher_id>/<tid>/
  // ══════════════════════════════════════════════════════
  Future<SalaryTransaction> updateTransaction({
    required int teacherId,
    required int transactionId,
    required double amountPaid,
    required int month,
    required int year,
    String? remarks,
  }) async {
    try {
      final res = await _dio.patch(
        ApiUrls.teacherSalaryTransactionDetail(teacherId, transactionId),
        data: {
          'amount_paid': amountPaid,
          'month': month,
          'year': year,
          if (remarks != null) 'remarks': remarks,
        },
      );

      final data = res.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return SalaryTransaction.fromJson(
          Map<String, dynamic>.from(data['data']),
        );
      }
      throw Exception(data['message'] ?? 'Failed to update transaction');
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['errors'] ?? data['message'] ?? e.message)
          : e.message;
      throw Exception('Update failed: $msg');
    }
  }

  // ══════════════════════════════════════════════════════
  // DELETE — delete transaction
  // ══════════════════════════════════════════════════════
  Future<bool> deleteTransaction({
    required int teacherId,
    required int transactionId,
  }) async {
    try {
      final res = await _dio.delete(
        ApiUrls.teacherSalaryTransactionDetail(teacherId, transactionId),
      );
      return (res.data as Map)['success'] == true;
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['message'] ?? e.message)
          : e.message;
      throw Exception('Delete failed: $msg');
    }
  }
}
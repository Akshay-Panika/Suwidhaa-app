// lib/feature/school/salary/repository/teacher_salary_repository.dart

import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../model/teacher_salary_model.dart';

class TeacherSalaryRepository {
  final Dio _dio = ApiClient.dio;

  /// GET salary summary (year-wise + month-wise)
  Future<TeacherSalarySummary> getSalarySummary(String teacherIdCard) async {
    final response = await _dio.get(
      '${ApiUrls.teacherSalarySummary}$teacherIdCard/',
    );

    final data = response.data;

    if (data is Map && data['success'] == true) {
      return TeacherSalarySummary.fromJson(
        Map<String, dynamic>.from(data['data']),
      );
    }

    throw Exception(data['message'] ?? 'Failed to load salary data');
  }

  /// POST — save salary payment
  Future<SalaryRecord> saveSalaryPayment({
    required String teacherIdCard,
    required String month,
    required String year,
    required String paymentMethod,
    required double amount,
    required double paidAmount,
    String? paidDate,
    String? remark,
  }) async {
    final response = await _dio.post(
      '${ApiUrls.teacherSalarySummary}$teacherIdCard/',
      data: {
        'month': month,
        'year': year,
        'payment_method': paymentMethod,
        'amount': amount,
        'paid_amount': paidAmount,
        if (paidDate != null) 'paid_date': paidDate,
        if (remark != null) 'remark': remark,
      },
    );

    final data = response.data;

    if (data is Map && data['success'] == true) {
      return SalaryRecord.fromJson(
        Map<String, dynamic>.from(data['data']),
      );
    }

    throw Exception(data['message'] ?? 'Failed to save salary');
  }

  /// DELETE — delete all records for a month + year
  Future<Map<String, dynamic>> deleteSalaryMonth({
    required String teacherIdCard,
    required String year,
    required String month,
  }) async {
    final response = await _dio.delete(
      '${ApiUrls.teacherSalarySummary}$teacherIdCard/$year/$month/',
    );

    final data = response.data;

    if (data is Map && data['success'] == true) {
      return Map<String, dynamic>.from(data['data'] ?? {});
    }

    throw Exception(data['message'] ?? 'Failed to delete salary');
  }
}
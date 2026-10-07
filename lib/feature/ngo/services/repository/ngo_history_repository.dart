import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ngo_history_model.dart';

class NgoHistoryRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /v1/ngo/history/donor/<donor_id>/
  Future<NgoDonorHistoryResponse> getHistoryByDonor(
      int donorId, {
        String? from,
        String? to,
      }) async {
    try {
      final response = await _dio.get(
        ApiUrls.ngoHistoryByDonor(donorId),
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return NgoDonorHistoryResponse.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load donation history',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Something went wrong',
      );
    }
  }

  /// POST /v1/ngo/history/create/
  /// Creates a new donation entry. Backend auto-updates the service's
  /// progress (total_amount, donor count).
  Future<NgoHistoryModel> createHistory(
      NgoHistoryCreateRequest request,
      ) async {
    try {
      final response = await _dio.post(
        ApiUrls.ngoHistoryCreate,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return NgoHistoryModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to create donation',
        );
      }
    } on DioException catch (e) {
      // Backend validation errors come back with `errors` map
      final data = e.response?.data;
      if (data is Map && data['errors'] != null) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.first;
        final msg = firstError is List ? firstError.first : firstError;
        throw Exception(msg.toString());
      }
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Something went wrong',
      );
    }
  }
}
// lib/feature/ott_platform/repository/webseries_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/webseries_model.dart';

class WebseriesRepository {
  final Dio _dio = ApiClient.dio;

  /// GET all webseries
  Future<WebseriesResponse> getWebseriesList() async {
    try {
      final response = await _dio.get(ApiUrls.ottWebSeriesList);

      if (response.statusCode == 200) {
        return WebseriesResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to load webseries: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ??
            e.message ??
            'Something went wrong',
      );
    }
  }

  /// GET single webseries by id
  Future<Webseries> getWebseriesDetail(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.ottWebSeriesDetail}$id/');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Webseries.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception('Failed to load webseries detail');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ?? e.message ?? 'Something went wrong',
      );
    }
  }
}
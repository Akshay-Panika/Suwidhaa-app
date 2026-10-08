import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/it_service_model.dart';

class ItServiceRepository {
  final Dio _dio = ApiClient.dio;

  /// GET — list all services (optional category filter)
  Future<List<ItServiceData>> getServices({int? categoryId}) async {
    try {
      final url = categoryId != null
          ? ApiUrls.itServiceListByCategory(categoryId)
          : ApiUrls.itServiceList;

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;

        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> list = body['data'];
          return list
              .map((json) => ItServiceData.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load IT services');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// GET — single service by ID
  Future<ItServiceData> getServiceById(int id) async {
    try {
      final response = await _dio.get(ApiUrls.itServiceDetail(id));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;

        if (body['success'] == true && body['data'] != null) {
          return ItServiceData.fromJson(body['data']);
        }
      }
      throw Exception('Failed to load IT service');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
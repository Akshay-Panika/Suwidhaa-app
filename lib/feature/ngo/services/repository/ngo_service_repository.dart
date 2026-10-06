import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ngo_service_model.dart';

class NgoServiceRepository {
  final Dio _dio = ApiClient.dio;

  /// Fetch all NGO services
  Future<List<NgoServiceData>> getServices() async {
    try {
      final response = await _dio.get(ApiUrls.ngoServiceList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          return dataList
              .map((json) => NgoServiceData.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load NGO services');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Fetch a single NGO service by id
  /// GET /api/v1/ngo/service/<id>/
  Future<NgoServiceData> getServiceById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.ngoServiceDetail}$id/');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          return NgoServiceData.fromJson(responseData['data']);
        }
      }
      throw Exception('Failed to load NGO service');
    } on DioException catch (e) {
      // 404 handling
      if (e.response?.statusCode == 404) {
        throw Exception(
          e.response?.data['message'] ?? 'Service not found',
        );
      }
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
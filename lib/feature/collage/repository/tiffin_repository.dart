// lib/feature/college/repositories/tiffin_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/tiffin_model.dart';

class TiffinRepository {
  final Dio _dio = ApiClient.dio;

  /// Get all tiffins
  Future<TiffinListResponse> getTiffins() async {
    try {
      final response = await _dio.get(ApiUrls.tiffinList);

      if (response.statusCode == 200) {
        return TiffinListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load tiffins: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get a specific tiffin by ID
  Future<Tiffin> getTiffinById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.tiffinDetail}$id/');

      if (response.statusCode == 200) {
        return Tiffin.fromJson(response.data);
      } else {
        throw Exception('Failed to load tiffin: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get tiffins by type (veg/non-veg)
  Future<TiffinListResponse> getTiffinsByType(String type) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (type.toLowerCase() == 'veg') {
        queryParams['is_veg'] = 'true';
      } else if (type.toLowerCase() == 'non-veg') {
        queryParams['is_nonveg'] = 'true';
      }

      final response = await _dio.get(
        ApiUrls.tiffinList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return TiffinListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load tiffins: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
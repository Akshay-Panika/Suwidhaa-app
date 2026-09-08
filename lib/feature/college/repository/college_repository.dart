// lib/repositories/college_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/college_model.dart';

class CollegeRepository {
  final Dio _dio = ApiClient.dio;

  /// Get all colleges
  Future<CollegeListResponse> getColleges() async {
    try {
      final response = await _dio.get(ApiUrls.collegeList);

      if (response.statusCode == 200) {
        return CollegeListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load colleges: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get a specific college by ID
  Future<College> getCollegeById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.collegeDetail}$id/');

      if (response.statusCode == 200) {
        return College.fromJson(response.data);
      } else {
        throw Exception('Failed to load college: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
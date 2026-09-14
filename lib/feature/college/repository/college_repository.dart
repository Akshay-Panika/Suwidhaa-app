import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:dio/dio.dart';

import '../../auth/controller/auth_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/college_model.dart';

class CollegeRepository {
  final Dio _dio = ApiClient.dio;

  /// Get all colleges
  Future<CollegeListResponse> getColleges() async {
    try {
      final AuthController authController = Get.find<AuthController>();
      final response = await _dio.get(
        '${ApiUrls.collegeList}${authController.getUserId}/',
      );

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

  /// ✅ Get a specific college by ID (with nested `data` handling)
  Future<College> getCollegeById(int id) async {
    try {
      final AuthController authController = Get.find<AuthController>();
      final url =
          '${ApiUrls.collegeDetail}$id/?user_id=${authController.getUserId}';

      print('🌐 getCollegeById URL: $url');

      final response = await _dio.get(url);

      print('📥 Response: ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;

        // ✅ API returns { "success": true, "data": { ...college fields... } }
        // so we need to extract the nested `data` object first
        final Map<String, dynamic>? collegeJson =
        (body is Map && body['data'] is Map)
            ? Map<String, dynamic>.from(body['data'])
            : null;

        if (collegeJson == null) {
          throw Exception('Invalid response: missing data');
        }

        return College.fromJson(collegeJson);
      } else {
        throw Exception('Failed to load college: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
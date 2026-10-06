import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ngo_category_model.dart';

class NgoCategoryRepository {
  final Dio _dio = ApiClient.dio;

  /// Fetch all NGO categories
  Future<List<NgoCategoryData>> getCategories() async {
    try {
      final response = await _dio.get(ApiUrls.ngoCategoryList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          return dataList
              .map((json) => NgoCategoryData.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load NGO categories');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  
}
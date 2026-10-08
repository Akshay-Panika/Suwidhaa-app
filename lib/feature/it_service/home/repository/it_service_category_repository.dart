import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/it_service_category_model.dart';

class ItServiceCategoryRepository {
  final Dio _dio = ApiClient.dio;

  /// GET - Fetch the list of IT Service categories
  Future<List<ItServiceCategoryData>> getItServiceCategories() async {
    try {
      final response = await _dio.get(ApiUrls.itServiceCategoryList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          return dataList
              .map((json) => ItServiceCategoryData.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load IT Service categories');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
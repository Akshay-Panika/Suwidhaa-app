// lib/feature/ecommerce/subcategory/repository/ecommerce_subcategory_repository.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ecommerce_subcategory_model.dart';

class EcommerceSubCategoryRepository {
  final Dio _dio = ApiClient.dio;

  Future<EcommerceSubCategoryResponse> fetchSubCategories({
    int? categoryId,
  }) async {
    try {
      final path = categoryId != null
          ? ApiUrls.ecommerceSubCategoryByCategory(categoryId)
          : ApiUrls.ecommerceSubCategoryList;

      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        return EcommerceSubCategoryResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to load sub-categories (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Network error while loading sub-categories',
      );
    }
  }
}
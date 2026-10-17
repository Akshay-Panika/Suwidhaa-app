// lib/feature/ecommerce/category/repository/ecommerce_category_repository.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ecommerce_category_model.dart';

class EcommerceCategoryRepository {
  final Dio _dio = ApiClient.dio;

  Future<EcommerceCategoryResponse> fetchCategories() async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceCategoryList);

      if (response.statusCode == 200) {
        return EcommerceCategoryResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to load categories (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Network error while loading categories',
      );
    }
  }
}
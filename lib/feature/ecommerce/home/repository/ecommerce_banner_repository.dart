// lib/feature/ecommerce/banner/repository/ecommerce_banner_repository.dart

import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../model/ecommerce_banner_model.dart';

class EcommerceBannerRepository {
  final Dio _dio = ApiClient.dio;

  Future<EcommerceBannerResponse> fetchBanners() async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceBannerList);

      if (response.statusCode == 200) {
        return EcommerceBannerResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw Exception('Failed to load banners (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error while loading banners',
      );
    }
  }
}
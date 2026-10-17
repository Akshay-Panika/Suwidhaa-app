// lib/feature/ecommerce/store/repository/ecommerce_store_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ecommerce_store_model.dart';

class EcommerceStoreRepository {
  final Dio _dio = ApiClient.dio;

  // GET STORE BY USER ID
  Future<EcommerceStoreResponse> getStoreByUser(int userId) async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceStoreGetByUser(userId));
      if (response.statusCode == 200) {
        return EcommerceStoreResponse.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch store (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error while fetching store');
    }
  }

  // CREATE STORE
  Future<bool> createStore({
    required int user,
    required String storeName,
    required String storeAddress,
    required String storePhone,
    required int storeCategory,
    File? storeLogo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user': user,
        'store_name': storeName,
        'store_address': storeAddress,
        'store_phone': storePhone,
        'store_category': storeCategory,
        if (storeLogo != null)
          'store_logo': await MultipartFile.fromFile(
            storeLogo.path,
            filename: storeLogo.path.split('/').last,
          ),
      });

      final response = await _dio.post(ApiUrls.ecommerceStoreCreate, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      throw Exception('Failed to create store (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error while creating store');
    }
  }

  // UPDATE STORE
  Future<bool> updateStore({
    required int storeId,
    required String storeName,
    required String storeAddress,
    required String storePhone,
    required int storeCategory,
    File? storeLogo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'store_name': storeName,
        'store_address': storeAddress,
        'store_phone': storePhone,
        'store_category': storeCategory,
        if (storeLogo != null)
          'store_logo': await MultipartFile.fromFile(
            storeLogo.path,
            filename: storeLogo.path.split('/').last,
          ),
      });

      final response = await _dio.patch(ApiUrls.ecommerceStoreDetail(storeId), data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      throw Exception('Failed to update store (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error while updating store');
    }
  }

  // DELETE STORE
  Future<bool> deleteStore(int storeId) async {
    try {
      final response = await _dio.delete(ApiUrls.ecommerceStoreDetail(storeId));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      throw Exception('Failed to delete store (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Network error while deleting store');
    }
  }
}
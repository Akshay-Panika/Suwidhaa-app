import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ecommerce_product_model.dart';

class EcommerceProductRepository {
  final Dio _dio = ApiClient.dio;

  // GET OWNER PRODUCTS
  Future<EcommerceProductResponse> fetchOwnerProducts(
      {required int userId}) async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceProductOwner(userId));
      if (response.statusCode == 200) {
        return EcommerceProductResponse.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to load owner products (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while loading owner products');
    }
  }

  // GET FEED
  Future<EcommerceProductResponse> fetchFeed(
      {required int user, int? subcategoryId}) async {
    try {
      final url =
      ApiUrls.ecommerceProductFeed(user, subcategoryId: subcategoryId);
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return EcommerceProductResponse.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to load products (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while loading feed');
    }
  }

  // GET FAVORITES
  Future<EcommerceProductResponse> fetchFavorites(
      {required int user}) async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceProductFavorites(user));
      if (response.statusCode == 200) {
        return EcommerceProductResponse.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to load favorites (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while loading favorites');
    }
  }

  // PATCH TOGGLE FAVORITE
  Future<bool> toggleFavorite(
      {required int id, required int userId}) async {
    try {
      final response = await _dio
          .patch(ApiUrls.ecommerceProductToggleFavorite(id, userId));
      if (response.statusCode == 200) {
        return response.data['data']?['is_favorite'] ?? false;
      }
      throw Exception('Failed to toggle favorite (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Network error while toggling');
    }
  }

  // GET SINGLE PRODUCT
  Future<EcommerceProductModel> fetchProductDetail({required int id}) async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceProductDetail(id));
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return EcommerceProductModel.fromJson(
              data['data'] as Map<String, dynamic>);
        }
        throw Exception('Product not found');
      }
      throw Exception('Failed to load product (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Network error while loading product');
    }
  }

  // 🆕 ADD TO CART
  Future<int> addToCart({
    required int productId,
    required int userId,
    int quantity = 1,
  }) async {
    try {
      final response = await _dio.post(
        ApiUrls.ecommerceCartAdd(productId),
        data: {'user': userId, 'quantity': quantity},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return (response.data['data']?['quantity'] as int?) ?? quantity;
      }
      throw Exception(
          response.data['message'] ?? 'Failed to add to cart');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while adding to cart');
    }
  }

  // 🆕 GET CART
  Future<EcommerceCartResponse> fetchCart({required int userId}) async {
    try {
      final response = await _dio.get(ApiUrls.ecommerceCartList(userId));
      if (response.statusCode == 200) {
        return EcommerceCartResponse.fromJson(
            response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to load cart (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while loading cart');
    }
  }

  // 🆕 REMOVE FROM CART (full delete ya quantity kam)
  Future<void> removeFromCart({
    required int productId,
    required int userId,
    int? quantity,
  }) async {
    try {
      final response = await _dio.delete(
        ApiUrls.ecommerceCartRemove(productId, userId, quantity: quantity),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove from cart');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while removing from cart');
    }
  }

  // POST CREATE
  Future<bool> createProduct({
    required int subcategory,
    required int user,
    required String title,
    required String description,
    required String price,
    required String oldPrice,
    required int stock,
    required String badge,
    required bool isActive,
    required List<File> images,
  }) async {
    try {
      final formData = FormData.fromMap({
        'subcategory': subcategory,
        'user': user,
        'title': title,
        'description': description,
        'price': price,
        'old_price': oldPrice,
        'stock': stock,
        'badge': badge,
        'is_active': isActive.toString(),
        'images': await Future.wait(
          images.map((file) async => await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          )),
        ),
      });

      final response =
      await _dio.post(ApiUrls.ecommerceProductCreate, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      throw Exception('Failed to create product (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while creating');
    }
  }

  // PATCH UPDATE PRODUCT
  Future<bool> updateProduct({
    required int id,
    required int subcategory,
    required int user,
    required String title,
    required String description,
    required String price,
    required String oldPrice,
    required int stock,
    required String badge,
    required bool isActive,
    required List<File> images,
  }) async {
    try {
      final data = {
        'subcategory': subcategory,
        'user': user,
        'title': title,
        'description': description,
        'price': price,
        'old_price': oldPrice,
        'stock': stock,
        'badge': badge,
        'is_active': isActive.toString(),
      };

      if (images.isNotEmpty) {
        final formData = FormData.fromMap({
          ...data,
          'images': await Future.wait(
            images.map((file) async => await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            )),
          ),
        });
        final response =
        await _dio.patch('v1/ecommerce/product/$id/', data: formData);
        return response.statusCode == 200;
      } else {
        final response =
        await _dio.patch('v1/ecommerce/product/$id/', data: data);
        return response.statusCode == 200;
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while updating');
    }
  }

  // DELETE PRODUCT
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dio.delete('v1/ecommerce/product/$id/');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'Network error while deleting');
    }
  }
}
// lib/feature/college/repositories/tiffin_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/tiffin_model.dart';

class TiffinRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  Future<TiffinListResponse> getTiffins({String? userId}) async {
    try {
      final queryParams = userId != null ? {'user_id': userId} : null;

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

  Future<Tiffin> createTiffin({
    required String title,
    required String description,
    required String price,
    required String nearCollege,
    required String isVeg,
    required String isNonveg,
    required String contactNumber,
    required String userId,
    List<File>? images,
  }) async {
    try {
      // Create FormData
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'near_college': nearCollege,
        'is_veg': isVeg,
        'is_nonveg': isNonveg,
        'contact_number': contactNumber,
        'user_id': userId,
      });

      // Add images if provided
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              'images', // Field name expected by API
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        ApiUrls.tiffinCreate,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Tiffin.fromJson(response.data);
      } else {
        throw Exception('Failed to create tiffin: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Tiffin> updateTiffin({
    required int tiffinId,
    String? title,
    String? description,
    String? price,
    String? nearCollege,
    String? isVeg,
    String? isNonveg,
    String? contactNumber,
    String? userId,
    List<File>? images,
    List<int>? imageIdsToDelete, // IDs of images to remove
  }) async {
    try {
      final Map<String, dynamic> data = {};

      // Add only fields that are provided
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (price != null) data['price'] = price;
      if (nearCollege != null) data['near_college'] = nearCollege;
      if (isVeg != null) data['is_veg'] = isVeg;
      if (isNonveg != null) data['is_nonveg'] = isNonveg;
      if (contactNumber != null) data['contact_number'] = contactNumber;
      if (userId != null) data['user_id'] = userId;
      if (imageIdsToDelete != null && imageIdsToDelete.isNotEmpty) {
        data['delete_image_ids'] = imageIdsToDelete.join(',');
      }

      // Create FormData
      final formData = FormData.fromMap(data);

      // Add new images if provided
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
              ),
            ),
          );
        }
      }

      final response = await _dio.put(
        '${ApiUrls.tiffinDetail}$tiffinId/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Tiffin.fromJson(response.data);
      } else {
        throw Exception('Failed to update tiffin: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ============================================================
  // DELETE TIFFIN
  // ============================================================
  Future<bool> deleteTiffin(int tiffinId) async {
    try {
      final response = await _dio.delete(
        '${ApiUrls.tiffinDetail}$tiffinId/',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete tiffin: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }


  Future<TiffinListResponse> getTiffinsByUserId(String userId) async {
    return getTiffins(userId: userId);
  }

  Future<Tiffin> updateTiffinWithJson({
    required int tiffinId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.tiffinDetail}$tiffinId/',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Tiffin.fromJson(response.data);
      } else {
        throw Exception('Failed to update tiffin: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
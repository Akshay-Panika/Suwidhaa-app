// lib/feature/college/repositories/room_repository.dart

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/room_model.dart';

class RoomRepository {
  final Dio _dio = ApiClient.dio;

  // ============================================================
  // GET ALL ROOMS
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/list/
  Future<RoomListResponse> getRooms() async {
    try {
      final response = await _dio.get(
        ApiUrls.roomList,
      );

      if (response.statusCode == 200) {
        return RoomListResponse.fromJson(response.data);
      }

      throw Exception(
        'Failed to load rooms: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // GET ROOMS BY USER ID
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/list/?user_id=9
  Future<RoomListResponse> getRoomsByUserId(
      String userId,
      ) async {
    try {
      final response = await _dio.get(
        ApiUrls.roomList,
        queryParameters: {
          'user_id': userId,
        },
      );

      if (response.statusCode == 200) {
        return RoomListResponse.fromJson(response.data);
      }

      throw Exception(
        'Failed to load user rooms: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // GET ROOM BY ID
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/{room_id}/
  Future<Room> getRoomById(
      int id,
      ) async {
    try {
      final response = await _dio.get(
        '${ApiUrls.roomDetail}$id/',
      );

      if (response.statusCode == 200) {
        return Room.fromJson(response.data);
      }

      throw Exception(
        'Failed to load room: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // CREATE ROOM
  // ============================================================

  /// POST
  /// /api/v1/college/rooms/create/
  ///
  /// Content-Type:
  /// multipart/form-data
  ///
  /// Images are uploaded using:
  /// images
  Future<RoomActionResponse> createRoom({
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
    required String roomType,
    String? contactNumber,
    bool wifi = false,
    bool ac = false,
    bool parking = false,
    bool security = false,
    bool laundry = false,
    bool water = false,
    String? nearCollege,
    List<String>? imagePaths,
  }) async {
    try {
      final formData = FormData();

      // ==========================
      // Basic Fields
      // ==========================

      formData.fields.add(
        MapEntry('user_id', userId),
      );

      formData.fields.add(
        MapEntry('title', title),
      );

      formData.fields.add(
        MapEntry('description', description),
      );

      formData.fields.add(
        MapEntry('address', address),
      );

      formData.fields.add(
        MapEntry('price', price),
      );

      formData.fields.add(
        MapEntry('room_type', roomType),
      );

      // ==========================
      // Optional Fields
      // ==========================

      if (contactNumber != null &&
          contactNumber.isNotEmpty) {
        formData.fields.add(
          MapEntry(
            'contact_number',
            contactNumber,
          ),
        );
      }

      if (nearCollege != null &&
          nearCollege.isNotEmpty) {
        formData.fields.add(
          MapEntry(
            'near_college',
            nearCollege,
          ),
        );
      }

      // ==========================
      // Amenities
      // ==========================

      formData.fields.add(
        MapEntry('wifi', wifi.toString()),
      );

      formData.fields.add(
        MapEntry('ac', ac.toString()),
      );

      formData.fields.add(
        MapEntry('parking', parking.toString()),
      );

      formData.fields.add(
        MapEntry('security', security.toString()),
      );

      formData.fields.add(
        MapEntry('laundry', laundry.toString()),
      );

      formData.fields.add(
        MapEntry('water', water.toString()),
      );

      // ==========================
      // Images
      // ==========================

      if (imagePaths != null &&
          imagePaths.isNotEmpty) {
        for (final path in imagePaths) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                path,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        ApiUrls.roomCreate,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return RoomActionResponse.fromJson(
          response.data,
        );
      }

      throw Exception(
        'Failed to create room: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // UPDATE ROOM
  // ============================================================

  /// PUT
  /// /api/v1/college/rooms/{room_id}/
  ///
  /// Content-Type:
  /// multipart/form-data
  Future<RoomActionResponse> updateRoom({
    required int roomId,
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
    required String roomType,
    String? contactNumber,
    bool wifi = false,
    bool ac = false,
    bool parking = false,
    bool security = false,
    bool laundry = false,
    bool water = false,
    String? nearCollege,
    List<String>? imagePaths,
  }) async {
    try {
      final formData = FormData();

      // ==========================
      // Basic Fields
      // ==========================

      formData.fields.add(
        MapEntry('user_id', userId),
      );

      formData.fields.add(
        MapEntry('title', title),
      );

      formData.fields.add(
        MapEntry('description', description),
      );

      formData.fields.add(
        MapEntry('address', address),
      );

      formData.fields.add(
        MapEntry('price', price),
      );

      formData.fields.add(
        MapEntry('room_type', roomType),
      );

      // ==========================
      // Optional Fields
      // ==========================

      formData.fields.add(
        MapEntry(
          'contact_number',
          contactNumber ?? '',
        ),
      );

      formData.fields.add(
        MapEntry(
          'near_college',
          nearCollege ?? '',
        ),
      );

      // ==========================
      // Amenities
      // ==========================

      formData.fields.add(
        MapEntry(
          'wifi',
          wifi.toString(),
        ),
      );

      formData.fields.add(
        MapEntry(
          'ac',
          ac.toString(),
        ),
      );

      formData.fields.add(
        MapEntry(
          'parking',
          parking.toString(),
        ),
      );

      formData.fields.add(
        MapEntry(
          'security',
          security.toString(),
        ),
      );

      formData.fields.add(
        MapEntry(
          'laundry',
          laundry.toString(),
        ),
      );

      formData.fields.add(
        MapEntry(
          'water',
          water.toString(),
        ),
      );

      // ==========================
      // New Images
      // ==========================

      if (imagePaths != null &&
          imagePaths.isNotEmpty) {
        for (final path in imagePaths) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                path,
              ),
            ),
          );
        }
      }

      final response = await _dio.put(
        '${ApiUrls.roomDetail}$roomId/',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        return RoomActionResponse.fromJson(
          response.data,
        );
      }

      throw Exception(
        'Failed to update room: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // DELETE ROOM
  // ============================================================

  /// DELETE
  /// /api/v1/college/rooms/{room_id}/
  Future<bool> deleteRoom(
      int roomId,
      ) async {
    try {
      final response = await _dio.delete(
        '${ApiUrls.roomDetail}$roomId/',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        return true;
      }

      throw Exception(
        'Failed to delete room: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unexpected error: $e',
      );
    }
  }

  // ============================================================
  // ERROR HANDLER
  // ============================================================

  String _getDioErrorMessage(
      DioException e,
      ) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          return data['message'].toString();
        }

        if (data['detail'] != null) {
          return data['detail'].toString();
        }
      }

      return 'Server error: ${e.response?.statusCode}';
    }

    return 'Network error: ${e.message}';
  }
}
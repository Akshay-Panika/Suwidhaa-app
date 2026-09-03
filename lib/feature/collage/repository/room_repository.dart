// lib/feature/college/repositories/room_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/room_model.dart';

class RoomRepository {
  final Dio _dio = ApiClient.dio;

  /// Get all rooms
  Future<RoomListResponse> getRooms() async {
    try {
      final response = await _dio.get(ApiUrls.roomList);

      if (response.statusCode == 200) {
        return RoomListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get a specific room by ID
  Future<Room> getRoomById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.roomDetail}$id/');

      if (response.statusCode == 200) {
        return Room.fromJson(response.data);
      } else {
        throw Exception('Failed to load room: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get rooms by type
  Future<RoomListResponse> getRoomsByType(String roomType) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (roomType.toLowerCase() != 'all') {
        queryParams['room_type'] = roomType;
      }

      final response = await _dio.get(
        ApiUrls.roomList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return RoomListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
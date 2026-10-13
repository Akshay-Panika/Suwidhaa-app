import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/it_service_model.dart';

class ItServiceRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<ItServiceData>> getServices({
    required int userId,
    int? categoryId,
  }) async {
    try {
      final url = categoryId != null
          ? ApiUrls.itServiceListByCategory(categoryId, userId)
          : ApiUrls.itServiceList(userId);

      print('📤 GET $url');

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> list = body['data'];
          return list.map((json) => ItServiceData.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load IT services');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🆕 POST — create a booking
  Future<bool> createBooking({
    required int userId,
    required int serviceId,
    required String fullName,
  }) async {
    try {
      print('📤 POST ${ApiUrls.itServiceBookingCreate}');

      final response = await _dio.post(
        ApiUrls.itServiceBookingCreate,
        data: {
          'user_id': userId,
          'service': serviceId,
          'full_name': fullName,
        },
      );

      print('📥 Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['success'] == true;
      }
      return false;
    } on DioException catch (e) {
      // 409 = already booked — treat as success-ish for UX
      if (e.response?.statusCode == 409) {
        return true;
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create booking',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🆕 DELETE — unbook a booking (hard delete)
  Future<bool> unbook({
    required int bookingId,
  }) async {
    try {
      final url = ApiUrls.itServiceBookingDelete(bookingId);
      print('📤 DELETE $url');

      final response = await _dio.delete(url);

      if (response.statusCode == 200) {
        return response.data['success'] == true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to unbook service',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ItServiceData> getServiceById(int id, int userId) async {
    try {
      final url = ApiUrls.itServiceDetail(id, userId);
      print('📤 GET $url');

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;
        if (body['success'] == true && body['data'] != null) {
          return ItServiceData.fromJson(body['data']);
        }
      }
      throw Exception('Failed to load IT service');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🆕 GET — services booked by a specific user
  Future<List<ItServiceData>> getBookedServices({
    required int userId,
    String? status,
  }) async {
    try {
      final url = ApiUrls.itServiceBookedList(userId, status: status);
      print('📤 GET $url');

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> list = body['data'];
          return list.map((json) => ItServiceData.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load booked services');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
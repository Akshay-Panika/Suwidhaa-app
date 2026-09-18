// lib/feature/college/repository/college_booking_repository.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../../auth/controller/auth_controller.dart';
import '../model/college_booking_model.dart';

class CollegeBookingRepository {
  final Dio _dio = ApiClient.dio;

  /// Create a college booking
  Future<CollegeBookingResponse> createBooking({
    required int collegeId,
    required String userId,
    required String message,
    BookingRoom? room,
    BookingTiffin? tiffin,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'college_id': collegeId,
        'user_id': userId,
        'booking': 'true',       // ✅ ADDED — backend safe rehne ke liye
        'message': message,
      };

      // ✅ Add room only if selected (using toJson)
      if (room != null) {
        data['room'] = room.toJson();
      }

      // ✅ Add tiffin only if selected (using toJson)
      if (tiffin != null) {
        data['tiffin'] = tiffin.toJson();
      }

      print('📤 Create Booking Data: $data');

      final response = await _dio.post(
        ApiUrls.collegeBooking,
        data: data,
      );

      print('📥 Create Booking Response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CollegeBookingResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        return CollegeBookingResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to book college: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException in createBooking: ${e.message}');
      print('❌ Response data: ${e.response?.data}');

      if (e.response?.data != null && e.response!.data is Map) {
        return CollegeBookingResponse.fromJson(
          e.response!.data,
        );
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error in createBooking: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get all college bookings for current user
  Future<CollegeBookingListResponse> getBookings() async {
    try {
      final AuthController authController = Get.find<AuthController>();
      final userId = authController.getUserId;

      final url = '${ApiUrls.collegeBookingList}?user_id=$userId';

      print('🌐 getBookings URL: $url');

      final response = await _dio.get(url);

      print('📥 getBookings response: ${response.data}');

      if (response.statusCode == 200) {
        return CollegeBookingListResponse.fromJson(
          response.data,
        );
      } else {
        throw Exception(
          'Failed to load bookings: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException in getBookings: ${e.message}');
      print('❌ Response: ${e.response?.data}');

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected in getBookings: $e');

      throw Exception('Unexpected error: $e');
    }
  }
}
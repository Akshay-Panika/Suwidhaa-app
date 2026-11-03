import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  /// 1. Send OTP
  Future<AuthResponse> sendOtp({required String phoneNumber}) async {
    try {
      print('📤 send-otp for: $phoneNumber');
      final response = await _dio.post(
        'v1/auth/send-otp/',
        data: {'phone_number': phoneNumber},
      );
      print('📥 send-otp response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      }
      return AuthResponse(
        success: false,
        error: 'Failed to send OTP. Please try again.',
      );
    } on DioException catch (e) {
      return AuthResponse(success: false, error: _extractError(e));
    } catch (e) {
      print('❌ sendOtp error: $e');
      return AuthResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  /// 2. Verify OTP
  Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      print('📤 verify-otp for: $phoneNumber | otp: $otp');
      final response = await _dio.post(
        'v1/auth/verify-otp/',
        data: {'phone_number': phoneNumber, 'otp': otp},
      );
      print('📥 verify-otp response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      }
      return AuthResponse(success: false, error: 'OTP verification failed.');
    } on DioException catch (e) {
      return AuthResponse(success: false, error: _extractError(e));
    } catch (e) {
      print('❌ verifyOtp error: $e');
      return AuthResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  /// 3. Logout
  Future<AuthResponse> logout({required String phoneNumber}) async {
    try {
      print('📤 logout for: $phoneNumber');
      final response = await _dio.post(
        'v1/auth/logout/',
        data: {'phone_number': phoneNumber},
      );
      print('📥 logout response: ${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      }
      return AuthResponse(success: false, error: 'Logout failed.');
    } on DioException catch (e) {
      return AuthResponse(success: false, error: _extractError(e));
    } catch (e) {
      return AuthResponse(success: false, error: 'Unexpected error: $e');
    }
  }

  /// 4. Delete user
  Future<bool> deleteUser(int userId) async {
    try {
      final response = await _dio.delete('v1/auth/users/$userId/delete/');
      print('📥 delete user response: ${response.data}');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('❌ deleteUser error: ${e.message}');
      return false;
    } catch (e) {
      print('❌ deleteUser error: $e');
      return false;
    }
  }

  String _extractError(DioException e) {
    print('❌ Dio error: ${e.message}');
    print('❌ Response: ${e.response?.data}');
    final data = e.response?.data;
    if (data is Map) {
      return data['error']?.toString() ??
          data['message']?.toString() ??
          data['detail']?.toString() ??
          'Network error occurred.';
    }
    return 'Network error. Please check your connection.';
  }
}
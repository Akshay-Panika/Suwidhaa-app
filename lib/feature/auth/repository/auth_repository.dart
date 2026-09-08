import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  // Authenticate user (register or login)
  Future<AuthResponse> authenticate({
    required String phoneNumber,
    String? name,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'phone_number': phoneNumber,
      };

      // Add name only if provided (for registration)
      if (name != null && name.isNotEmpty) {
        data['name'] = name;
      }

      print('📤 Sending auth request: $data');

      final response = await _dio.post(
        'v1/auth/auth/',
        data: data,
      );

      print('📥 Auth response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          error: 'Failed to authenticate. Please try again.',
        );
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      if (e.response != null) {
        print('❌ Response data: ${e.response?.data}');
        return AuthResponse(
          success: false,
          error: e.response?.data['error'] ?? 'Network error occurred.',
        );
      }
      return AuthResponse(
        success: false,
        error: 'Network error. Please check your connection.',
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      return AuthResponse(
        success: false,
        error: 'An unexpected error occurred.',
      );
    }
  }

  // Get all users (for testing)
  Future<List<UserData>> getAllUsers() async {
    try {
      final response = await _dio.get('v1/auth/users/');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> users = data['data'] ?? [];
          return users.map((user) => UserData.fromJson(user)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error fetching users: $e');
      return [];
    }
  }

  // Delete user
  Future<bool> deleteUser(int userId) async {
    try {
      final response = await _dio.delete('v1/auth/users/$userId/delete/');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }
}
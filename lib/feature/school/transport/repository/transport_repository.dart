// lib/feature/school/transport/repository/transport_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/transport_model.dart';

class TransportRepository {
  final Dio dio = ApiClient.dio;

  // ==================== GET LIST ====================
  Future<TransportListResponse> getTransportList() async {
    try {
      final response = await dio.get(ApiUrls.transportList);

      if (response.statusCode == 200) {
        return TransportListResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load transport data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== GET DETAIL ====================
  Future<TransportModel?> getTransportDetail(int id) async {
    try {
      final response = await dio.get('${ApiUrls.transportDetail}$id/');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return TransportModel.fromJson(data['data']);
        }
        return null;
      } else {
        throw Exception(
            'Failed to load transport detail: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== ADD STUDENT TO TRANSPORT ====================
  Future<bool> addStudentToTransport({
    required int transportId,
    required String studentName,
    required String studentId,
    required String pickupTime,
    required String dropTime,
    required String address,
  }) async {
    try {
      final formData = FormData.fromMap({
        'student_name': studentName,
        'student_id': studentId,
        'pickup_time': pickupTime,
        'drop_time': dropTime,
        'address': address,
      });

      final response = await dio.post(
        '${ApiUrls.transportAddStudent}$transportId/students/add/',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to add student');
        }
      } else {
        throw Exception('Failed to add student: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== CREATE TRANSPORT ====================
  Future<TransportModel> createTransport({
    required String transportType,
    required String schoolType,
    required String vehicleNumber,
    required String driverName,
    required String driverNumber,
    String? capacity,
    String? routeName,
    File? driverImage,
  }) async {
    try {
      // Build FormData
      final Map<String, dynamic> formMap = {
        'transport_type': transportType,
        'school_type': schoolType,
        'vehicle_number': vehicleNumber,
        'driver_name': driverName,
        'driver_number': driverNumber,
      };

      if (capacity != null && capacity.isNotEmpty) {
        formMap['capacity'] = capacity;
      }
      if (routeName != null && routeName.isNotEmpty) {
        formMap['route_name'] = routeName;
      }

      // Attach image if available
      if (driverImage != null) {
        final fileName = driverImage.path.split('/').last;
        formMap['driver_image'] = await MultipartFile.fromFile(
          driverImage.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await dio.post(
        ApiUrls.transportCreate,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return TransportModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to create transport');
        }
      } else {
        throw Exception(
            'Failed to create transport: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Extract backend error message if available
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteTransport(int id) async {
    try {
      final response = await dio.delete('${ApiUrls.transportDetail}$id/');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to delete transport');
        }
      } else {
        throw Exception('Failed to delete transport: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== REMOVE STUDENT FROM TRANSPORT ====================
  Future<bool> removeStudentFromTransport({
    required int transportId,
    required String studentId,
  }) async {
    try {
      final response = await dio.delete(
        '${ApiUrls.transportRemoveStudent}$transportId/students/$studentId/delete/',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to remove student');
        }
      } else {
        throw Exception('Failed to remove student: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
// lib/feature/school/transport/repository/transport_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/transport_model.dart';

class TransportRepository {
  final Dio dio = ApiClient.dio;

  // ============================================================
  // SCHOOL ID RESOLVERS
  // ============================================================
  Future<int> _activeSchoolIdOrThrow() async {
    if (await SchoolAuthSharedPrefService.isTeacherLoggedIn()) {
      final school = await SchoolAuthSharedPrefService.getTeacherSchoolData();
      final id = _extractSchoolId(school);
      if (id != null && id > 0) return id;
    }
    if (await SchoolAuthSharedPrefService.isStudentLoggedIn()) {
      final school = await SchoolAuthSharedPrefService.getStudentSchoolData();
      final id = _extractSchoolId(school);
      if (id != null && id > 0) return id;
    }
    throw Exception('School not found. Please log in again.');
  }

  Future<int> _teacherSchoolIdOrThrow() async {
    final school = await SchoolAuthSharedPrefService.getTeacherSchoolData();
    final id = _extractSchoolId(school);
    if (id == null || id <= 0) {
      throw Exception('Teacher school not found. Please log in again.');
    }
    return id;
  }

  int? _extractSchoolId(Map<String, dynamic>? data) {
    if (data == null) return null;
    final raw = data['id'] ?? data['school_id'] ?? data['schoolId'];
    if (raw == null) return null;
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  // ==================== GET LIST (SCHOOL-WISE) ====================
  Future<TransportListResponse> getTransportList() async {
    try {
      final schoolId = await _activeSchoolIdOrThrow();
      final response =
      await dio.get(ApiUrls.transportListBySchool(schoolId));
      if (response.statusCode == 200) {
        return TransportListResponse.fromJson(response.data);
      }
      throw Exception(
          'Failed to load transport data: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return TransportListResponse(success: true, count: 0, data: []);
      }
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== GET DETAIL ====================
  Future<TransportModel?> getTransportDetail(int id) async {
    try {
      final response = await dio.get(ApiUrls.transportDetailById(id));
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return TransportModel.fromJson(data['data']);
        }
        return null;
      }
      throw Exception(
          'Failed to load transport detail: ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== CREATE ====================
  Future<TransportModel> createTransport({
    required String transportType,
    required String vehicleNumber,
    required String driverName,
    required String driverNumber,
    String? capacity,
    String? routeName,
    File? driverImage,
  }) async {
    try {
      final schoolId = await _teacherSchoolIdOrThrow();

      final Map<String, dynamic> formMap = {
        'school_id': schoolId,
        'transport_type': transportType,
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
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return TransportModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to create transport');
      }
      throw Exception('Failed to create transport: ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== ✅ NEW: UPDATE ====================
  Future<TransportModel> updateTransport({
    required int id,
    required String transportType,
    required String vehicleNumber,
    required String driverName,
    required String driverNumber,
    String? capacity,
    String? routeName,
    File? driverImage,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'transport_type': transportType,
        'vehicle_number': vehicleNumber,
        'driver_name': driverName,
        'driver_number': driverNumber,
      };

      // Text fields — bhejo even if empty so backend can clear them
      formMap['capacity'] = (capacity ?? '').toString();
      formMap['route_name'] = (routeName ?? '').toString();

      // Only attach new file if user picked one (existing image stays if not)
      if (driverImage != null) {
        final fileName = driverImage.path.split('/').last;
        formMap['driver_image'] = await MultipartFile.fromFile(
          driverImage.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await dio.put(
        ApiUrls.transportDetailById(id),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return TransportModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to update transport');
      }
      throw Exception('Failed to update transport: ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteTransport(int id) async {
    try {
      final response = await dio.delete(ApiUrls.transportDetailById(id));
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) return true;
        throw Exception(data['message'] ?? 'Failed to delete transport');
      }
      throw Exception('Failed to delete transport: ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== ADD STUDENT ====================
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
        'student_id': studentId,
        'pickup_time': pickupTime,
        'drop_time': dropTime,
        'address': address,
      });

      final response = await dio.post(
        ApiUrls.transportAddStudent(transportId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) return true;
        throw Exception(data['message'] ?? 'Failed to add student');
      }
      throw Exception('Failed to add student: ${response.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== REMOVE STUDENT ====================
  Future<bool> removeStudentFromTransport({
    required int transportId,
    required String studentId,
  }) async {
    try {
      final response = await dio.delete(
        ApiUrls.transportRemoveStudent(transportId, studentId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) return true;
        throw Exception(data['message'] ?? 'Failed to remove student');
      }
      throw Exception('Failed to remove student: ${response.statusCode}');
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
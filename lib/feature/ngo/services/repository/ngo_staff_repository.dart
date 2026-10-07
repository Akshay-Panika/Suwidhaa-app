import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../model/ngo_staff_model.dart';

class NgoStaffRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /api/v1/ngo/staff/list/
  Future<List<NgoStaffModel>> getNgoStaffList() async {
    try {
      final response = await _dio.get(ApiUrls.ngoStaffList);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => NgoStaffModel.fromJson(e)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load NGO staff',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Something went wrong',
      );
    }
  }

  /// GET /api/v1/ngo/staff/<id>/
  Future<NgoStaffModel> getNgoStaffDetail(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.ngoStaffDetail}$id/');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return NgoStaffModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load NGO staff',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Something went wrong',
      );
    }
  }
}
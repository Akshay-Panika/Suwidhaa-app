// lib/feature/school/transport/repository/transport_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/transport_model.dart';

class TransportRepository {
  final Dio dio = ApiClient.dio;

  Future<TransportListResponse> getTransportList() async {
    try {
      final response = await dio.get(ApiUrls.transportList);

      if (response.statusCode == 200) {
        return TransportListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load transport data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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
        throw Exception('Failed to load transport detail: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
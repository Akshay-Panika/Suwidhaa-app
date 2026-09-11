// lib/feature/ott_platform/repository/ott_reel_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/ott_reel_model.dart';

class OttReelRepository {
  final Dio _dio = ApiClient.dio;

  Future<OttReelModel> getReels() async {
    try {
      final response = await _dio.get(ApiUrls.ottReelList);
      return OttReelModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to load reels',
      );
    }
  }
}
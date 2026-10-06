import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../model/ngo_banner_model.dart';

class NgoBannerRepository {
  final Dio _dio = ApiClient.dio;

  /// Fetch the list of NGO banners
  Future<List<NgoBannerData>> getNgoBanners() async {
    try {
      final response = await _dio.get(ApiUrls.ngoBannerList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          return dataList.map((json) => NgoBannerData.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load NGO banners');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
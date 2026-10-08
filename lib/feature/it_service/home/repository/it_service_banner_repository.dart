import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/it_service_banner_model.dart';

class ItServiceBannerRepository {
  final Dio _dio = ApiClient.dio;

  /// GET - Fetch the list of IT Service banners
  Future<List<ItServiceBannerData>> getItServiceBanners() async {
    try {
      final response = await _dio.get(ApiUrls.itServiceBannerList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          return dataList
              .map((json) => ItServiceBannerData.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load IT Service banners');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
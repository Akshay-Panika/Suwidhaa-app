import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/college_banner_model.dart';


class CollegeBannerRepository {
  final Dio _dio = ApiClient.dio;

  Future<CollegeBannerModel> getBanners() async {
    try {
      final response = await _dio.get(
        ApiUrls.collegeBannerList,
      );

      if (response.statusCode == 200) {
        return CollegeBannerModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }
}
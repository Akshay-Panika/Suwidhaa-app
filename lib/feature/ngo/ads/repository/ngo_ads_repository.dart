import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ngo_ads_model.dart';

class NgoAdsRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<NgoAdsModel>> getAds({bool? isHome}) async {
    try {
      final params = <String, dynamic>{};
      if (isHome != null) params['is_home'] = isHome;

      final res = await _dio.get(
        ApiUrls.ngoAdsList,
        queryParameters: params.isEmpty ? null : params,
      );
      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? const [];
        return list
            .map((e) => NgoAdsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return const [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map && (e.response!.data as Map)['error'] != null) {
      return (e.response!.data as Map)['error'].toString();
    }
    return 'Something went wrong. Please try again.';
  }
}
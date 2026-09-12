import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/ott_model.dart';

class OttRepository {
  final Dio _dio = ApiClient.dio;

  /// 🔹 Fetch all OTT content (Home list)
  Future<List<OttModel>> fetchAllContents() async {
    final response = await _dio.get(ApiUrls.ottContent);

    final data = response.data['data'];
    if (data is List) {
      return data
          .map((e) => OttModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// 🔹 Fetch detail by content ID + content type
  ///
  /// content_type → path
  ///   movie      → v1/ott/movies/<id>/
  ///   cartoon    → v1/ott/cartoons/<id>/
  ///   sci_fi     → v1/ott/sci-fi/<id>/
  ///   sport      → v1/ott/sports/<id>/
  ///   web_series → v1/ott/web-series/<id>/
  Future<OttModel> fetchContentDetail({
    required int id,
    required String contentType,
  }) async {
    final path = '${ApiUrls.ottDetailPath(contentType)}$id/';
    final response = await _dio.get(path);

    final data = response.data['data'];
    return OttModel.fromJson(data as Map<String, dynamic>);
  }
}
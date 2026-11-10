import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ott_tvshows_model.dart';

class OttTvShowsRepository {
  final Dio _dio = ApiClient.dio;

  /// GET v1/ott/tvshows/{id}/
  Future<OttTvShowsModel> fetchTvShowsDetail(int id) async {
    try {
      final url = '${ApiUrls.ottTvShowsDetail}$id/';
      final res = await _dio.get(url);
      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return OttTvShowsModel.fromJson(
          Map<String, dynamic>.from(data['data'] as Map),
        );
      }
      throw Exception('Failed to fetch TV show detail');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map &&
        (e.response!.data as Map)['error'] != null) {
      return (e.response!.data as Map)['error'].toString();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ott_ads_model.dart';

class OttAdsRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<OttAdsModel>> getAds({bool? isHome}) async {
    try {
      final res = await _dio.get(
        ApiUrls.ottAdsList,
        queryParameters: isHome == null ? null : {'is_home': isHome},
      );
      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? const [];
        return list
            .map((e) => OttAdsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return const [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<OttAdsModel> updateAd({
    required int id,
    required String title,
    required String videoUrl,
    required String navigateScreen,
    required bool isHome,
    PlatformFile? imageFile,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'video_url': videoUrl,
        'navigate_screen': navigateScreen,
        'is_home': isHome ? 'true' : 'false',
      };

      if (imageFile != null) {
        map['image'] = await _toMultipart(imageFile);
      }

      final res = await _dio.put(
        '${ApiUrls.ottAdsDetail}$id/',
        data: FormData.fromMap(map),
      );

      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return OttAdsModel.fromJson(
            Map<String, dynamic>.from(data['data'] as Map));
      }
      throw Exception(_extractError(data) ?? 'Update failed');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      final res = await _dio.delete('${ApiUrls.ottAdsDetail}$id/');
      final data = res.data;
      if (data is Map<String, dynamic> && data['success'] == true) return;
      throw Exception(_extractError(data) ?? 'Delete failed');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<MultipartFile?> _toMultipart(PlatformFile? file) async {
    if (file == null) return null;
    if (file.bytes != null) {
      return MultipartFile.fromBytes(file.bytes!, filename: file.name);
    }
    if (file.path != null) {
      return MultipartFile.fromFile(file.path!, filename: file.name);
    }
    return null;
  }

  String? _extractError(dynamic data) {
    if (data is Map) {
      if (data['error'] != null) return data['error'].toString();
      if (data['errors'] is Map) {
        final first = (data['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    }
    return null;
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map &&
        (e.response!.data as Map)['errors'] != null) {
      final errs = (e.response!.data as Map)['errors'];
      if (errs is Map && errs.isNotEmpty) {
        final first = errs.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    }
    if (e.response?.data is Map && (e.response!.data as Map)['error'] != null) {
      return (e.response!.data as Map)['error'].toString();
    }
    return 'Something went wrong. Please try again.';
  }
}
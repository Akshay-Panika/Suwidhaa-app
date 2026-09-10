import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/ott_content_model.dart';

class OttContentRepository {
  Future<List<OttContentModel>> getContents() async {
    try {
      final response = await ApiClient.dio.get(
        ApiUrls.ottContent,
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List data = response.data['data'] ?? [];

        return data
            .map(
              (json) => OttContentModel.fromJson(
            json,
          ),
        )
            .toList();
      }

      throw Exception(
        response.data['message'] ??
            'Failed to fetch OTT content',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Network error',
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    }
  }
}
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/ott_category_model.dart';

class OttCategoryRepository {
  /// GET — list all categories
  Future<List<OttCategoryModel>> getCategories() async {
    final response = await ApiClient.dio.get(ApiUrls.ottCategory);
    final body = response.data;

    final List raw = (body is Map && body['data'] is List)
        ? body['data'] as List
        : (body is List ? body : []);

    return raw
        .map((e) => OttCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
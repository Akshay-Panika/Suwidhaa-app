import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/school_event_model.dart';

class SchoolEventRepository {
  final Dio _dio = ApiClient.dio;

  // Get all events
  Future<SchoolEventListResponse> getEventList() async {
    try {
      final response = await _dio.get(ApiUrls.scheduleList);
      if (response.statusCode == 200) {
        return SchoolEventListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load events');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading events: $e');
    }
  }

  // Get single event by ID
  Future<SchoolEventModel> getEventById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.scheduleDetail}$id/');
      if (response.statusCode == 200) {
        return SchoolEventModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load event');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading event: $e');
    }
  }
}
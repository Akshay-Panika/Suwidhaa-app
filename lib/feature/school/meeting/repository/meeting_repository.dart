import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/meeting_model.dart';

class MeetingRepository {
  final Dio _dio = ApiClient.dio;

  /// CREATE
  Future<MeetingModel> createMeeting(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post(ApiUrls.meetingCreate, data: body);
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception(data['errors'] ?? 'Failed to create meeting');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// LIST
  Future<List<MeetingModel>> getMeetings({
    String? forMeeting,
    String? className,
    String? date,
  }) async {
    try {
      final res = await _dio.get(ApiUrls.meetingList, queryParameters: {
        if (forMeeting != null) 'for_meeting': forMeeting,
        if (className != null) 'class_name': className,
        if (date != null) 'date': date,
      });
      final data = res.data;
      if (data is Map && data['success'] == true) {
        final list = (data['data'] as List? ?? []);
        return list.map((e) => MeetingModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// DETAIL
  Future<MeetingModel> getMeetingById(int id) async {
    try {
      final res = await _dio.get(ApiUrls.meetingDetail(id));
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception('Meeting not found');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// UPDATE (PUT)
  Future<MeetingModel> updateMeeting(int id, Map<String, dynamic> body) async {
    try {
      final res = await _dio.put(ApiUrls.meetingDetail(id), data: body);
      final data = res.data;
      if (data is Map && data['success'] == true && data['data'] != null) {
        return MeetingModel.fromJson(data['data']);
      }
      throw Exception('Failed to update meeting');
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  /// DELETE
  Future<bool> deleteMeeting(int id) async {
    try {
      final res = await _dio.delete('${ApiUrls.meetingDelete}$id/');
      final data = res.data;
      return data is Map && data['success'] == true;
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  String _extractError(DioException e) {
    final res = e.response?.data;
    if (res is Map) {
      if (res['errors'] != null) return res['errors'].toString();
      if (res['detail'] != null) return res['detail'].toString();
      if (res['message'] != null) return res['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
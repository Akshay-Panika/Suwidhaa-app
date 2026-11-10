import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/record_class_model.dart';
import '../model/record_subject_model.dart';
import '../model/record_video_model.dart';

class RecordVideoRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<RecordClassModel>> getClasses() async {
    final res = await _dio.get(ApiUrls.recordVideoClasses);
    if (res.data['status'] == true) {
      return (res.data['data'] as List).map((e) => RecordClassModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<RecordSubjectModel>> getSubjects(int classId) async {
    final res = await _dio.get(ApiUrls.recordVideoSubjects(classId));
    if (res.data['status'] == true) {
      return (res.data['data'] as List).map((e) => RecordSubjectModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<RecordVideoModel>> getVideos(int classId, {int? subjectId}) async {
    final url = ApiUrls.recordVideoList(classId, subjectId: subjectId);
    final res = await _dio.get(url);
    if (res.data['status'] == true) {
      return (res.data['data'] as List).map((e) => RecordVideoModel.fromJson(e)).toList();
    }
    return [];
  }
}
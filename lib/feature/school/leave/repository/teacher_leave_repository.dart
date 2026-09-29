import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/teacher_leave_model.dart';

class TeacherLeaveRepository {
  final Dio _dio = ApiClient.dio;

  /// CREATE leave (multipart form-data with optional image)
  Future<Map<String, dynamic>> createLeave({
    required String teacherId,
    required String teacherIdCard,
    required bool applyStatus,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'teacher_id': teacherId,
      'teacher_id_card': teacherIdCard,
      'apply_status': applyStatus.toString(),
      'reason_msg': reasonMsg,
      'start_date': startDate,
      'end_date': endDate,
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    final response = await _dio.post(
      ApiUrls.teacherLeaveCreate,
      data: formData,
    );
    return response.data;
  }

  /// LIST all leaves
  Future<List<TeacherLeaveModel>> getAllLeaves() async {
    final response = await _dio.get(ApiUrls.teacherLeaveList);
    final data = response.data;
    if (data['status'] == true) {
      return (data['data'] as List)
          .map((e) => TeacherLeaveModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET leaves by teacher id card
  Future<List<TeacherLeaveModel>> getLeavesByTeacherIdCard(
      String teacherIdCard) async {
    final response = await _dio.get(
      '${ApiUrls.teacherLeaveByIdCard}$teacherIdCard/',
    );
    final data = response.data;
    if (data['status'] == true) {
      return (data['data'] as List)
          .map((e) => TeacherLeaveModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET single leave by id
  Future<TeacherLeaveModel?> getLeaveById(int id) async {
    final response = await _dio.get('${ApiUrls.teacherLeaveDetail}$id/');
    final data = response.data;
    if (data['status'] == true) {
      return TeacherLeaveModel.fromJson(data['data']);
    }
    return null;
  }

  /// DELETE leave by id
  Future<Map<String, dynamic>> deleteLeave(int id) async {
    final response = await _dio.delete(
      '${ApiUrls.teacherLeaveDetail}$id/',
    );
    return response.data;
  }
}
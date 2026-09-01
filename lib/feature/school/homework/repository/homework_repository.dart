import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/homework_model.dart';

class HomeworkRepository {
  final Dio _dio = ApiClient.dio;

  // Get all homework
  Future<HomeworkResponse> getHomeworkList() async {
    try {
      final response = await _dio.get(ApiUrls.homeworkList);
      if (response.statusCode == 200) {
        return HomeworkResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load homework list');
      }
    } catch (e) {
      throw Exception('Error loading homework: $e');
    }
  }

  // Get single homework by ID
  Future<HomeworkResponse> getHomeworkById(int id) async {
    try {
      final response = await _dio.get('${ApiUrls.homeworkDetail}$id/');
      if (response.statusCode == 200) {
        return HomeworkResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load homework');
      }
    } catch (e) {
      throw Exception('Error loading homework: $e');
    }
  }

  // Create homework with image
  Future<HomeworkResponse> createHomework({
    required String subjectName,
    required String subjectTopic,
    required String issueDate,
    required String endDate,
    required String schoolType,
    required String className,
    required String teacherName,
    required String teacherId,
    dynamic imageFile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'subject_name': subjectName,
        'subject_topic': subjectTopic,
        'issue_date': issueDate,
        'end_date': endDate,
        'school_type': schoolType,
        'class_name': className,
        'teacher_name': teacherName,
        'teacher_id': teacherId,
      });

      // Add image if provided
      if (imageFile != null) {
        if (imageFile is String) {
          // If image is a file path
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                imageFile,
                filename: imageFile.split('/').last,
              ),
            ),
          );
        } else {
          // If image is XFile or File
          final path = imageFile.path;
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        ApiUrls.homeworkCreate,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeworkResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to create homework');
      }
    } catch (e) {
      throw Exception('Error creating homework: $e');
    }
  }

  // Update homework
  Future<HomeworkResponse> updateHomework({
    required int id,
    String? subjectName,
    String? subjectTopic,
    String? issueDate,
    String? endDate,
    String? schoolType,
    String? className,
    String? teacherName,
    String? teacherId,
    dynamic imageFile,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (subjectName != null) data['subject_name'] = subjectName;
      if (subjectTopic != null) data['subject_topic'] = subjectTopic;
      if (issueDate != null) data['issue_date'] = issueDate;
      if (endDate != null) data['end_date'] = endDate;
      if (schoolType != null) data['school_type'] = schoolType;
      if (className != null) data['class_name'] = className;
      if (teacherName != null) data['teacher_name'] = teacherName;
      if (teacherId != null) data['teacher_id'] = teacherId;

      FormData formData = FormData.fromMap(data);

      // Add image if provided
      if (imageFile != null) {
        if (imageFile is String) {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                imageFile,
                filename: imageFile.split('/').last,
              ),
            ),
          );
        } else {
          final path = imageFile.path;
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await _dio.put(
        '${ApiUrls.homeworkDetail}$id/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return HomeworkResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to update homework');
      }
    } catch (e) {
      throw Exception('Error updating homework: $e');
    }
  }

  // Delete homework
  Future<bool> deleteHomework(int id) async {
    try {
      final response = await _dio.delete('${ApiUrls.homeworkDetail}$id/');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete homework');
      }
    } catch (e) {
      throw Exception('Error deleting homework: $e');
    }
  }
}
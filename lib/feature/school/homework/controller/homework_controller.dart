import 'package:get/get.dart';
import '../repository/homework_repository.dart';
import '../model/homework_model.dart';

class HomeworkController extends GetxController {
  final HomeworkRepository _repo = HomeworkRepository();

  final homeworkList = <HomeworkModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> fetchAllHomework() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _repo.getAllHomework();
      homeworkList.assignAll(res.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHomeworkByTeacher(String teacherId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _repo.getHomeworkByTeacher(teacherId);
      homeworkList.assignAll(res.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ NEW: student-wise list
  Future<void> fetchHomeworkByStudent(String studentIdCard) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _repo.getHomeworkByStudent(studentIdCard);
      homeworkList.assignAll(res.data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<HomeworkModel?> fetchHomeworkById(int id) async {
    try {
      return await _repo.getHomeworkById(id);
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  Future<bool> createHomework({
    required String schoolType,
    required String className,
    required String subject,
    required String subjectTopic,
    required String issueDate,
    required String endDate,
    required List<StudentHomeworkEntry> students,
    required String teacherId,
    String? imagePath,
  }) async {
    try {
      final hw = await _repo.createHomework(
        schoolType: schoolType,
        className: className,
        subject: subject,
        subjectTopic: subjectTopic,
        issueDate: issueDate,
        endDate: endDate,
        students: students,
        teacherId: teacherId,
        imagePath: imagePath,
      );
      return hw.id != null;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> updateHomework({
    required int id,
    required String schoolType,
    required String className,
    required String subject,
    required String subjectTopic,
    required String issueDate,
    required String endDate,
    required List<StudentHomeworkEntry> students,
    required String teacherId,
    String? imagePath,
  }) async {
    try {
      final hw = await _repo.updateHomework(
        id: id,
        schoolType: schoolType,
        className: className,
        subject: subject,
        subjectTopic: subjectTopic,
        issueDate: issueDate,
        endDate: endDate,
        students: students,
        teacherId: teacherId,
        imagePath: imagePath,
      );
      return hw.id != null;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> deleteHomework(int id) async {
    try {
      return await _repo.deleteHomework(id);
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> toggleStudentStatus({
    required int homeworkId,
    required String studentIdcard,
    bool? explicitStatus,
  }) async {
    try {
      return await _repo.toggleStudentStatus(
        homeworkId: homeworkId,
        studentIdcard: studentIdcard,
        explicitStatus: explicitStatus,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }
}
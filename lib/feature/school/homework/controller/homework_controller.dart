import 'package:get/get.dart';
import '../model/homework_model.dart';
import '../repository/homework_repository.dart';

class HomeworkController extends GetxController {
  final _repo = HomeworkRepository();

  // ── State ──
  final RxBool isLoading = false.obs;
  final RxList<HomeworkModel> homeworkList = <HomeworkModel>[].obs;
  final RxString errorMessage = ''.obs;

  // ── Teacher ID (set after login) ──
  String teacherId = '';
  String teacherName = '';
  String schoolType = '';

  Future<void> fetchAllHomework() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      homeworkList.clear();
      final res = await _repo.getAllHomework();
      if (res.success) {
        homeworkList.assignAll(res.data);
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  // ══════════════════════════════════════════════════════
  // TOGGLE STUDENT STATUS
  // ══════════════════════════════════════════════════════
  Future<bool> toggleStudentStatus({
    required int homeworkId,
    required String studentIdcard,
    bool? explicitStatus,
  }) async {
    try {
      final ok = await _repo.toggleStudentStatus(
        homeworkId: homeworkId,
        studentIdcard: studentIdcard,
        explicitStatus: explicitStatus,
      );

      if (ok) {
        // Refresh homework to get accurate state
        final updated = await _repo.getHomeworkById(homeworkId);
        if (updated != null) {
          // Update in list if present
          final idx = homeworkList.indexWhere((e) => e.id == homeworkId);
          if (idx >= 0) {
            homeworkList[idx] = updated;
            homeworkList.refresh();
          }
        }
      }
      return ok;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<void> fetchHomeworkByTeacher(String teacherId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      homeworkList.clear();
      final res = await _repo.getHomeworkByTeacher(teacherId);
      if (res.success) {
        homeworkList.assignAll(res.data);
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // GET BY SCHOOL TYPE + CLASS (for student screen)
  // ══════════════════════════════════════════════════════
  Future<void> fetchHomeworkByClass({
    required String schoolType,
    required String className,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final res = await _repo.getHomeworkByClass(
        schoolType: schoolType,
        className: className,
      );
      if (res.success) {
        homeworkList.assignAll(res.data);
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
// ══════════════════════════════════════════════════════
// GET BY ID — no isLoading toggle (screen handles its own loading)
// ══════════════════════════════════════════════════════
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
    required String teacherName,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
      final hw = await _repo.createHomework(
        schoolType: schoolType,
        className: className,
        subject: subject,
        subjectTopic: subjectTopic,
        issueDate: issueDate,
        endDate: endDate,
        students: students,
        teacherId: teacherId,
        teacherName: teacherName,
        imagePath: imagePath,
      );
      homeworkList.insert(0, hw);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // UPDATE
  // ══════════════════════════════════════════════════════
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
    required String teacherName,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
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
        teacherName: teacherName,
        imagePath: imagePath,
      );
      final idx = homeworkList.indexWhere((e) => e.id == id);
      if (idx >= 0) {
        homeworkList[idx] = hw;
      } else {
        homeworkList.insert(0, hw);
      }
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // DELETE
  // ══════════════════════════════════════════════════════
  Future<bool> deleteHomework(int id) async {
    try {
      isLoading.value = true;
      final ok = await _repo.deleteHomework(id);
      if (ok) homeworkList.removeWhere((e) => e.id == id);
      return ok;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/teacher_leave_model.dart';
import '../repository/teacher_leave_repository.dart';

class TeacherLeaveController extends GetxController {
  final TeacherLeaveRepository _repository = TeacherLeaveRepository();

  final RxBool isLoading = false.obs;
  final RxList<TeacherLeaveModel> leaves = <TeacherLeaveModel>[].obs;

  bool _hasLoaded = false;

  Future<bool> createLeave({
    required String teacherId,
    required String teacherIdCard,
    required bool applyStatus,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
      final result = await _repository.createLeave(
        teacherId: teacherId,
        teacherIdCard: teacherIdCard,
        applyStatus: applyStatus,
        reasonMsg: reasonMsg,
        startDate: startDate,
        endDate: endDate,
        imagePath: imagePath,
      );

      if (result['status'] == true) {
        _hasLoaded = false;
        FlutterToast.success(
            result['message'] ?? 'Leave applied successfully');
        return true;
      } else {
        FlutterToast.error(
            result['errors']?.toString() ?? 'Failed to apply leave');
        return false;
      }
    } catch (e) {
      FlutterToast.error('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeavesByTeacherIdCard(
      String teacherIdCard, {
        bool forceRefresh = false,
      }) async {
    if (_hasLoaded && !forceRefresh && leaves.isNotEmpty) return;
    try {
      isLoading.value = true;
      final list =
      await _repository.getLeavesByTeacherIdCard(teacherIdCard);
      leaves.assignAll(list);
      _hasLoaded = true;
    } catch (e) {
      FlutterToast.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteLeave(int id) async {
    try {
      isLoading.value = true;
      final result = await _repository.deleteLeave(id);

      if (result['status'] == true) {
        leaves.removeWhere((l) => l.id == id);
        FlutterToast.success(
            result['message'] ?? 'Leave deleted successfully');
        return true;
      } else {
        FlutterToast.error(
            result['message']?.toString() ?? 'Failed to delete leave');
        return false;
      }
    } catch (e) {
      FlutterToast.error('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    _hasLoaded = false;
    leaves.clear();
  }
}
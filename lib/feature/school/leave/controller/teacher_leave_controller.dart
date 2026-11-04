// lib/feature/school/leave/controller/teacher_leave_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/teacher_leave_model.dart';
import '../repository/teacher_leave_repository.dart';

class TeacherLeaveController extends GetxController {
  final TeacherLeaveRepository _repository = TeacherLeaveRepository();

  final RxBool isLoading = false.obs;
  final RxList<TeacherLeaveModel> leaves = <TeacherLeaveModel>[].obs;
  final RxString errorMessage = ''.obs;

  bool _hasLoaded = false;

  // ══════════════════════════════════════════════════════
  // CREATE — teacher_id + id_card read from SharedPrefs
  // apply_status defaults to 'pending' on backend
  // ══════════════════════════════════════════════════════
  Future<bool> createLeave({
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    final teacherCard =
    await SchoolAuthSharedPrefService.getTeacherIdCard();

    if (teacherId == null || teacherId <= 0) {
      FlutterToast.error('Teacher ID not found. Please login again.');
      return false;
    }
    if ((teacherCard ?? '').trim().isEmpty) {
      FlutterToast.error('Teacher ID card not found. Please login again.');
      return false;
    }

    try {
      isLoading.value = true;
      final result = await _repository.createLeave(
        teacherId: teacherId.toString(),
        teacherIdCard: teacherCard!.trim(),
        reasonMsg: reasonMsg,
        startDate: startDate,
        endDate: endDate,
        imagePath: imagePath,
      );

      if (result['status'] == true) {
        _hasLoaded = false;
        fetchLeavesByTeacherId(forceRefresh: true);
        FlutterToast.success(
            result['message'] ?? 'Leave applied successfully');
        return true;
      }
      FlutterToast.error(
          result['errors']?.toString() ?? 'Failed to apply leave');
      return false;
    } catch (e) {
      FlutterToast.error('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // ✅ NEW: UPDATE STATUS ONLY
  // ══════════════════════════════════════════════════════
  Future<bool> updateLeaveStatus({
    required int id,
    required String status, // 'pending' | 'approved' | 'rejected'
  }) async {
    try {
      final result = await _repository.updateLeaveStatus(
        id: id,
        status: status,
      );

      if (result['status'] == true) {
        // Replace leave in list with fresh data
        final updatedData = result['data'];
        if (updatedData is Map) {
          try {
            final updated = TeacherLeaveModel.fromJson(
              Map<String, dynamic>.from(updatedData),
            );
            final idx = leaves.indexWhere((e) => e.id == id);
            if (idx >= 0) {
              leaves[idx] = updated;
              leaves.refresh();
            }
          } catch (_) {}
        }

        FlutterToast.success(
          result['message'] ?? 'Leave status updated',
        );
        return true;
      }
      FlutterToast.error(
        result['message']?.toString() ?? 'Failed to update status',
      );
      return false;
    } catch (e) {
      FlutterToast.error('Error: $e');
      return false;
    }
  }

  // ══════════════════════════════════════════════════════
  // FETCH MY LEAVES — teacher_id from SharedPrefs
  // ══════════════════════════════════════════════════════
  Future<void> fetchLeavesByTeacherId({
    bool forceRefresh = false,
  }) async {
    if (_hasLoaded && !forceRefresh && leaves.isNotEmpty) return;

    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    if (teacherId == null || teacherId <= 0) {
      errorMessage.value = 'Teacher ID not found. Please login again.';
      FlutterToast.error(errorMessage.value);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await _repository.getLeavesByTeacherId(teacherId);
      leaves.assignAll(list);
      _hasLoaded = true;
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // FETCH SCHOOL LEAVES
  // ══════════════════════════════════════════════════════
  Future<void> fetchLeavesBySchool() async {
    final schoolData =
    await SchoolAuthSharedPrefService.getTeacherSchoolData();
    final schoolId = int.tryParse('${schoolData?['id'] ?? ''}');

    if (schoolId == null || schoolId <= 0) {
      errorMessage.value = 'School ID not found.';
      FlutterToast.error(errorMessage.value);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await _repository.getLeavesBySchool(schoolId);
      leaves.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // ══════════════════════════════════════════════════════
  // ✅ UPDATE — edit leave
  // ══════════════════════════════════════════════════════
  Future<bool> updateLeave({
    required int id,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
      final result = await _repository.updateLeave(
        id: id,
        reasonMsg: reasonMsg,
        startDate: startDate,
        endDate: endDate,
        imagePath: imagePath,
      );

      if (result['status'] == true) {
        final updatedData = result['data'];
        if (updatedData is Map) {
          try {
            final updated = TeacherLeaveModel.fromJson(
              Map<String, dynamic>.from(updatedData),
            );
            final idx = leaves.indexWhere((e) => e.id == id);
            if (idx >= 0) {
              leaves[idx] = updated;
              leaves.refresh();
            }
          } catch (_) {}
        }
        FlutterToast.success(
            result['message'] ?? 'Leave updated successfully');
        return true;
      }
      FlutterToast.error(
          result['errors']?.toString() ?? 'Failed to update leave');
      return false;
    } catch (e) {
      FlutterToast.error('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // ✅ FETCH ONE — refresh detail after edit
  // ══════════════════════════════════════════════════════
  Future<TeacherLeaveModel?> fetchById(int id) async {
    try {
      return await _repository.getLeaveById(id);
    } catch (_) {
      return null;
    }
  }

  // ══════════════════════════════════════════════════════
  // DELETE
  // ══════════════════════════════════════════════════════
  Future<bool> deleteLeave(int id) async {
    try {
      isLoading.value = true;
      final result = await _repository.deleteLeave(id);

      if (result['status'] == true) {
        leaves.removeWhere((l) => l.id == id);
        FlutterToast.success(
            result['message'] ?? 'Leave deleted successfully');
        return true;
      }
      FlutterToast.error(
          result['message']?.toString() ?? 'Failed to delete leave');
      return false;
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
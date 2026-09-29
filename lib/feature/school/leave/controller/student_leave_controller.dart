// lib/feature/school/student_leave/controller/student_leave_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../profile/controller/teacher_controller.dart';
import '../../profile/controller/student_controller.dart';  // ✅ ADD
import '../model/student_leave_list_model.dart';
import '../repository/student_leave_repository.dart';

class StudentLeaveController extends GetxController {
  final StudentLeaveRepository _repository = StudentLeaveRepository();

  // ────── Teacher info source ──────
  final TeacherController _teacherController = Get.find<TeacherController>();

  // ────── Student info source (card id ke liye) ──────
  final StudentController _studentController = Get.find<StudentController>();

  // ==================== STATE ====================
  final RxList<StudentLeaveData> allRequests = <StudentLeaveData>[].obs;
  final RxList<StudentLeaveData> filteredRequests = <StudentLeaveData>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isFetchingDetail = false.obs;

  final RxString selectedClass = 'All'.obs;
  final RxString selectedStatus = 'All'.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();

    // ✅ Student card id lo — StudentController se
    final studentCardId = _studentController.studentData.value?.studentIdCard;

    if (studentCardId != null && studentCardId.isNotEmpty) {
      fetchStudentLeaveByCardId(studentCardId);
    } else {
      // fallback: agar student card id nahi mili to all list
      fetchStudentLeaveList();
    }
  }

  // ==================== GET BY CARD ID ✅ NEW ====================
  Future<void> fetchStudentLeaveByCardId(String studentCardId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
      await _repository.getStudentLeaveByCardId(studentCardId);

      if (response.status) {
        allRequests.assignAll(response.data);
        _applyFilters();
      } else {
        errorMessage.value = response.message ?? 'Failed to load data';
        FlutterToast.error(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


  Future<StudentLeaveData?> getLeaveById(int leaveId) async {
    try {
      isFetchingDetail.value = true;

      final response = await _repository.getLeaveById(leaveId);

      if (response.status && response.data != null) {
        // local list me update karo (agar already hai)
        final index = allRequests.indexWhere((r) => r.id == leaveId);
        if (index != -1) {
          allRequests[index] = response.data!;
          allRequests.refresh();
          _applyFilters();
        } else {
          allRequests.insert(0, response.data!);
          _applyFilters();
        }
        return response.data;
      } else {
        FlutterToast.error(response.message ?? 'Leave not found');
        return null;
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return null;
    } finally {
      isFetchingDetail.value = false;
    }
  }

// ═══════════════════════════════════════════════════
// UPDATE LEAVE
// ═══════════════════════════════════════════════════
  Future<bool> updateLeave({
    required int leaveId,
    required String studentIdCard,
    required String studentName,
    required String studentClass,
    required String schoolType,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
    bool removeOldImage = false,
  }) async {
    try {
      isUpdating.value = true;

      final response = await _repository.updateLeave(
        leaveId: leaveId,
        studentIdCard: studentIdCard,
        studentName: studentName,
        studentClass: studentClass,
        schoolType: schoolType,
        reasonMsg: reasonMsg,
        startDate: startDate,
        endDate: endDate,
        imagePath: imagePath,
        removeOldImage: removeOldImage,
      );

      if (response.status && response.data != null) {
        // local list update
        final index = allRequests.indexWhere((r) => r.id == leaveId);
        if (index != -1) {
          allRequests[index] = response.data!;
          allRequests.refresh();
          _applyFilters();
        }

        FlutterToast.success(response.message ?? 'Leave updated successfully');
        return true;
      } else {
        FlutterToast.error(response.message ?? 'Failed to update leave');
        return false;
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

// ═══════════════════════════════════════════════════
// DELETE LEAVE
// ═══════════════════════════════════════════════════
  Future<bool> deleteLeave(StudentLeaveData leave) async {
    if (isDeleting.value) return false;

    try {
      isDeleting.value = true;

      final response = await _repository.deleteLeave(leave.id);

      if (response.status) {
        // local list se hata do
        allRequests.removeWhere((r) => r.id == leave.id);
        _applyFilters();

        FlutterToast.success(
          response.message ?? 'Leave deleted successfully',
        );
        return true;
      } else {
        FlutterToast.error(response.message ?? 'Failed to delete leave');
        return false;
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isDeleting.value = false;
    }
  }


  // ==================== GET LIST (All) ====================
  Future<void> fetchStudentLeaveList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getStudentLeaveList();

      if (response.status) {
        allRequests.assignAll(response.data);
        _applyFilters();
      } else {
        errorMessage.value = response.message ?? 'Failed to load data';
        FlutterToast.error(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createLeave({
    required String studentIdCard,
    required String studentName,
    required String studentClass,
    required String schoolType,
    required String reasonMsg,
    required String startDate,
    required String endDate,
    String? imagePath,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.createLeave(
        studentIdCard: studentIdCard,
        studentName: studentName,
        studentClass: studentClass,
        schoolType: schoolType,
        reasonMsg: reasonMsg,
        startDate: startDate,
        endDate: endDate,
        imagePath: imagePath,
      );

      if (response.status) {
        FlutterToast.success(
          response.message ?? 'Leave applied successfully',
        );

        // 🔹 Naya leave list me add kar do (turant UI update)
        if (response.data != null) {
          allRequests.insert(0, response.data!);
          _applyFilters();
        }

        return true;
      } else {
        FlutterToast.error(response.message ?? 'Failed to apply leave');
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  // ==================== PATCH APPROVAL ====================
  Future<void> updateLeaveApproval({
    required StudentLeaveData request,
    required String newStatus,
  }) async {
    if (isUpdating.value) return;

    final teacherCardId = _teacherController.teacherIdCard;
    final teacherName = _teacherController.fullName;

    if (teacherCardId.isEmpty || teacherName.isEmpty) {
      FlutterToast.error('Teacher info not available. Please try again.');
      return;
    }

    try {
      isUpdating.value = true;

      final response = await _repository.updateLeaveApproval(
        leaveId: request.id,
        status: newStatus,
        teacherCardId: teacherCardId,
        teacherName: teacherName,
      );

      if (response.status) {
        if (response.data != null) {
          final index =
          allRequests.indexWhere((r) => r.id == response.data!.id);
          if (index != -1) {
            allRequests[index] = response.data!;
            allRequests.refresh();
          }
        } else {
          final index = allRequests.indexWhere((r) => r.id == request.id);
          if (index != -1) {
            allRequests[index] = allRequests[index]
                .copyWith(leaveStatus: newStatus.toLowerCase());
            allRequests.refresh();
          }
        }
        _applyFilters();

        FlutterToast.success(
          response.message ?? 'Leave $newStatus successfully',
        );
      } else {
        FlutterToast.error(response.message ?? 'Failed to update leave');
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isUpdating.value = false;
    }
  }

  // ==================== FILTERS ====================
  List<String> getUniqueClasses() {
    final set = <String>{};
    for (final r in allRequests) {
      if (r.studentClass.isNotEmpty) set.add(r.studentClass);
    }
    final list = set.toList()..sort();
    return ['All', ...list];
  }

  void setClassFilter(String value) {
    selectedClass.value = value;
    _applyFilters();
  }

  void setStatusFilter(String value) {
    selectedStatus.value = value;
    _applyFilters();
  }

  void setDateFilter(DateTime? date) {
    selectedDate.value = date;
    _applyFilters();
  }

  void clearFilters() {
    selectedClass.value = 'All';
    selectedStatus.value = 'All';
    selectedDate.value = null;
    _applyFilters();
  }

  void _applyFilters() {
    filteredRequests.assignAll(
      allRequests.where((r) {
        final classMatch = selectedClass.value == 'All' ||
            r.studentClass == selectedClass.value;
        final statusMatch = selectedStatus.value == 'All' ||
            r.displayStatus == selectedStatus.value;
        final dateMatch = _matchesDateFilter(r);
        return classMatch && statusMatch && dateMatch;
      }).toList(),
    );
  }

  bool _matchesDateFilter(StudentLeaveData req) {
    if (selectedDate.value == null) return true;
    try {
      final from = DateTime.parse(req.startDate);
      final to = DateTime.parse(req.endDate);
      final target = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
      );
      return !target.isBefore(from) && !target.isAfter(to);
    } catch (_) {
      return false;
    }
  }

  int get pendingCount => allRequests.where((r) => r.isPending).length;

  bool get hasActiveFilters =>
      selectedClass.value != 'All' ||
          selectedStatus.value != 'All' ||
          selectedDate.value != null;
}
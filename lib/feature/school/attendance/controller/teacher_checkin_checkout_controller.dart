// lib/feature/school/attendance/controller/teacher_checkin_checkout_controller.dart

import 'package:get/get.dart';
import '../model/teacher_checkin_checkout_model.dart';
import '../repository/teacher_checkin_checkout_repository.dart';

class TeacherCheckInOutController extends GetxController {
  final TeacherCheckInOutRepository _repository = TeacherCheckInOutRepository();

  // ─────────────────────────────────────────────
  // Reactive state
  // ─────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isCheckingIn = false.obs;
  final RxBool isCheckingOut = false.obs;
  final RxString errorMessage = ''.obs;

  /// Today's attendance data (check-in/out time + status)
  final Rxn<CheckInOutData> todayData = Rxn<CheckInOutData>();

  // ─────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────
  bool get hasCheckedIn => todayData.value?.hasCheckedIn ?? false;
  bool get hasCheckedOut => todayData.value?.hasCheckedOut ?? false;
  bool get hasTodayRecord => todayData.value != null;

  String? get checkInTime => todayData.value?.checkInTime;
  String? get checkOutTime => todayData.value?.checkOutTime;

  // ─────────────────────────────────────────────
  // Fetch Today's Attendance
  // ─────────────────────────────────────────────
  Future<void> fetchToday({required String teacherId}) async {
    if (teacherId.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getToday(teacherId: teacherId);

      todayData.value = result.data;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Check In
  // ─────────────────────────────────────────────
  Future<bool> checkIn({
    required String teacherId,
    String remarks = 'self',
  }) async {
    if (isCheckingIn.value) return false;

    try {
      isCheckingIn.value = true;
      errorMessage.value = '';

      final result = await _repository.checkIn(
        teacherId: teacherId,
        remarks: remarks,
      );

      if (result.status && result.data != null) {
        todayData.value = result.data;
        return true;
      }
      errorMessage.value = result.message ?? 'Check-in failed';
      return false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCheckingIn.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Check Out
  // ─────────────────────────────────────────────
  Future<bool> checkOut({
    required String teacherId,
    String remarks = 'self',
  }) async {
    if (isCheckingOut.value) return false;

    try {
      isCheckingOut.value = true;
      errorMessage.value = '';

      final result = await _repository.checkOut(
        teacherId: teacherId,
        remarks: remarks,
      );

      if (result.status && result.data != null) {
        todayData.value = result.data;
        return true;
      }
      errorMessage.value = result.message ?? 'Check-out failed';
      return false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isCheckingOut.value = false;
    }
  }

  void clearError() => errorMessage.value = '';

  @override
  void onClose() {
    todayData.value = null;
    super.onClose();
  }
}
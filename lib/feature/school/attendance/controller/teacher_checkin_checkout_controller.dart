// lib/feature/school/attendance/controller/teacher_checkin_checkout_controller.dart
import 'package:get/get.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/teacher_checkin_checkout_model.dart';
import '../repository/teacher_checkin_checkout_repository.dart';

class TeacherCheckInOutController extends GetxController {
  final TeacherCheckInOutRepository _repository =
  TeacherCheckInOutRepository();

  final RxBool isLoading = false.obs;
  final RxBool isCheckingIn = false.obs;
  final RxBool isCheckingOut = false.obs;
  final RxString errorMessage = ''.obs;

  final Rxn<CheckInOutData> todayData = Rxn<CheckInOutData>();

  bool get hasCheckedIn => todayData.value?.hasCheckedIn ?? false;
  bool get hasCheckedOut => todayData.value?.hasCheckedOut ?? false;
  bool get hasTodayRecord => todayData.value != null;

  String? get checkInTime => todayData.value?.checkInTime;
  String? get checkOutTime => todayData.value?.checkOutTime;

  // ─────────────────────────────────────────────────────
  Future<String?> _resolveTeacherId() async {
    final id = await SchoolAuthSharedPrefService.getTeacherId();
    if (id == null || id <= 0) return null;
    return id.toString();
  }

  // ══════════════════════════════════════════════════════
  // FETCH TODAY
  // ══════════════════════════════════════════════════════
  Future<void> fetchToday() async {
    final teacherId = await _resolveTeacherId();
    if (teacherId == null) {
      errorMessage.value = 'Teacher ID not found. Please login again.';
      return;
    }

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

  // ══════════════════════════════════════════════════════
  // CHECK IN
  // ══════════════════════════════════════════════════════
  Future<bool> checkIn({String remarks = 'self'}) async {
    if (isCheckingIn.value) return false;

    final teacherId = await _resolveTeacherId();
    if (teacherId == null) {
      errorMessage.value = 'Teacher ID not found. Please login again.';
      return false;
    }

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

  // ══════════════════════════════════════════════════════
  // CHECK OUT
  // ══════════════════════════════════════════════════════
  Future<bool> checkOut({String remarks = 'self'}) async {
    if (isCheckingOut.value) return false;

    final teacherId = await _resolveTeacherId();
    if (teacherId == null) {
      errorMessage.value = 'Teacher ID not found. Please login again.';
      return false;
    }

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
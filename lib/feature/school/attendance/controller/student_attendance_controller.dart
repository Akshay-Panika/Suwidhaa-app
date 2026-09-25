// lib/controller/student_attendance_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/student_attendance_model.dart';
import '../repository/student_attendance_repository.dart';

class StudentAttendanceController extends GetxController {
  final StudentAttendanceRepository _repository = StudentAttendanceRepository();

  final isLoading = false.obs;
  final attendanceData = Rxn<StudentAttendanceIdwiseModel>();

  final monthWiseRecords = <String, List<AttendanceRecord>>{}.obs;
  final selectedYear = ''.obs;
  final selectedMonth = ''.obs;
  final isSubmitting = false.obs;
  final lastSubmitResponse = Rxn<StudentAttendanceCreateResponse>();

  Future<void> fetchStudentAttendance(String studentCardId) async {
    try {
      isLoading.value = true;
      final result = await _repository.getStudentAttendanceById(studentCardId);
      attendanceData.value = result;
      _prepareMonthWiseRecords(result);
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitBulkAttendance(
      List<StudentAttendanceItem> items) async {
    if (items.isEmpty) {
      FlutterToast.warning('Koi student select nahi hai');
      return false;
    }

    try {
      isSubmitting.value = true;
      lastSubmitResponse.value = null;

      final result = await _repository.createBulkAttendance(items);
      lastSubmitResponse.value = result;

      if (result.status) {
        FlutterToast.success(result.message.isEmpty
            ? 'Attendance saved successfully'
            : result.message);
        return true;
      } else {
        FlutterToast.error('Failed to save attendance');
        return false;
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
  void _prepareMonthWiseRecords(StudentAttendanceIdwiseModel data) {
    monthWiseRecords.clear();
    final history = data.history;

    if (history.isEmpty) return;

    // latest year select
    final years = history.keys.toList()..sort((a, b) => b.compareTo(a));
    selectedYear.value = years.first;

    final months = history[selectedYear.value]!;
    final monthKeys = months.keys.toList();

    for (final month in monthKeys) {
      // key: "September 2026" format
      monthWiseRecords['$month ${selectedYear.value}'] = months[month]!;
    }

    if (monthWiseRecords.isNotEmpty) {
      selectedMonth.value = monthWiseRecords.keys.first;
    }
  }

  List<AttendanceRecord> get selectedMonthRecords {
    if (selectedMonth.value.isEmpty) return [];
    return monthWiseRecords[selectedMonth.value] ?? [];
  }

  void changeMonth(String monthKey) {
    selectedMonth.value = monthKey;
  }

  @override
  void onClose() {
    monthWiseRecords.clear();
    super.onClose();
  }
}
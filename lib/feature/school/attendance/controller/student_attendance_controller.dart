// lib/feature/school/attendance/controller/student_attendance_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/student_attendance_model.dart';
import '../repository/student_attendance_repository.dart';

class StudentAttendanceController extends GetxController {
  final StudentAttendanceRepository _repository = StudentAttendanceRepository();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ================= DATA FOR UI =================
  final attendanceData = Rxn<StudentAttendanceIdwiseModel>();
  final todayAttendanceData = Rxn<TodayAttendanceModel>();

  // ================= CALENDAR STATE =================
  final attendanceMap = <DateTime, AttendanceRecord>{}.obs;
  final availableMonths = <DateTime>[].obs;
  final focusedDay = DateTime.now().obs;
  final currentMonthIndex = 0.obs;

  // ================= BULK SUBMIT STATE =================
  final isSubmitting = false.obs;
  final lastSubmitResponse = Rxn<StudentAttendanceCreateResponse>();

  // ─────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────
  bool get hasData =>
      attendanceData.value != null &&
          attendanceData.value!.history.isNotEmpty;

  bool get canGoPrev => currentMonthIndex.value > 0;
  bool get canGoNext => currentMonthIndex.value < availableMonths.length - 1;

  // ─────────────────────────────────────────────
  // ✅ PROXY METHOD (For Bulk Fetching without overwriting state)
  // ─────────────────────────────────────────────
  Future<TodayAttendanceModel> getStudentTodayAttendance(int studentId) async {
    return await _repository.getTodayAttendance(studentId);
  }

  // ─────────────────────────────────────────────
  // 1) Fetch Student History (Date-wise)
  // ─────────────────────────────────────────────
  Future<void> fetchStudentAttendance({int? studentId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getStudentAttendanceById(studentId: studentId);
      attendanceData.value = result;

      _prepareCalendarData(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // 2) Fetch Today's Attendance (For individual screen)
  // ─────────────────────────────────────────────
  Future<void> fetchTodayAttendance(int studentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getTodayAttendance(studentId);
      todayAttendanceData.value = result;

    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Calendar Data Preparation
  // ─────────────────────────────────────────────
  void _prepareCalendarData(StudentAttendanceIdwiseModel data) {
    attendanceMap.clear();
    availableMonths.clear();

    final history = data.history;
    if (history.isEmpty) return;

    history.forEach((yearStr, months) {
      final year = int.tryParse(yearStr) ?? 0;
      if (year == 0) return;

      months.forEach((monthName, records) {
        final monthNum = _monthNumber(monthName);
        final monthDate = DateTime(year, monthNum, 1);

        availableMonths.add(monthDate);

        for (final r in records) {
          try {
            final parts = r.date.split('-');
            final d = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            attendanceMap[d] = r;
          } catch (_) {}
        }
      });
    });

    availableMonths.sort((a, b) => a.compareTo(b));

    if (availableMonths.isNotEmpty) {
      currentMonthIndex.value = availableMonths.length - 1;
      focusedDay.value = availableMonths.last;
    } else {
      currentMonthIndex.value = 0;
      focusedDay.value = DateTime.now();
    }
  }

  int _monthNumber(String monthName) {
    const map = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12,
    };
    return map[monthName] ?? 1;
  }

  // ─────────────────────────────────────────────
  // Calendar Navigation
  // ─────────────────────────────────────────────
  void goToPreviousMonth() {
    if (!canGoPrev) return;
    currentMonthIndex.value--;
    focusedDay.value = availableMonths[currentMonthIndex.value];
  }

  void goToNextMonth() {
    if (!canGoNext) return;
    currentMonthIndex.value++;
    focusedDay.value = availableMonths[currentMonthIndex.value];
  }

  // ─────────────────────────────────────────────
  // Bulk Submit (Class Attendance Screen)
  // ─────────────────────────────────────────────
  Future<bool> submitBulkAttendance(List<StudentAttendanceItem> items) async {
    if (items.isEmpty) {
      FlutterToast.warning('Not Selected Student');
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
}
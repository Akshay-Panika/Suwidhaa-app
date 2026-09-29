// // lib/controller/student_attendance_controller.dart
// import 'package:get/get.dart';
// import '../../../../core/widget/flutter_toast.dart';
// import '../model/student_attendance_model.dart';
// import '../repository/student_attendance_repository.dart';
//
// class StudentAttendanceController extends GetxController {
//   final StudentAttendanceRepository _repository = StudentAttendanceRepository();
//
//   final isLoading = false.obs;
//   final attendanceData = Rxn<StudentAttendanceIdwiseModel>();
//
//   final monthWiseRecords = <String, List<AttendanceRecord>>{}.obs;
//   final selectedYear = ''.obs;
//   final selectedMonth = ''.obs;
//   final isSubmitting = false.obs;
//   final lastSubmitResponse = Rxn<StudentAttendanceCreateResponse>();
//
//   Future<void> fetchStudentAttendance(String studentCardId) async {
//     try {
//       isLoading.value = true;
//       final result = await _repository.getStudentAttendanceById(studentCardId);
//       attendanceData.value = result;
//       _prepareMonthWiseRecords(result);
//     } catch (e) {
//       FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> submitBulkAttendance(
//       List<StudentAttendanceItem> items) async {
//     if (items.isEmpty) {
//       FlutterToast.warning('Not Selected Student');
//       return false;
//     }
//
//     try {
//       isSubmitting.value = true;
//       lastSubmitResponse.value = null;
//
//       final result = await _repository.createBulkAttendance(items);
//       lastSubmitResponse.value = result;
//
//       if (result.status) {
//         FlutterToast.success(result.message.isEmpty
//             ? 'Attendance saved successfully'
//             : result.message);
//         return true;
//       } else {
//         FlutterToast.error('Failed to save attendance');
//         return false;
//       }
//     } catch (e) {
//       FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
//       return false;
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//   void _prepareMonthWiseRecords(StudentAttendanceIdwiseModel data) {
//     monthWiseRecords.clear();
//     final history = data.history;
//
//     if (history.isEmpty) return;
//
//     // latest year select
//     final years = history.keys.toList()..sort((a, b) => b.compareTo(a));
//     selectedYear.value = years.first;
//
//     final months = history[selectedYear.value]!;
//     final monthKeys = months.keys.toList();
//
//     for (final month in monthKeys) {
//       // key: "September 2026" format
//       monthWiseRecords['$month ${selectedYear.value}'] = months[month]!;
//     }
//
//     if (monthWiseRecords.isNotEmpty) {
//       selectedMonth.value = monthWiseRecords.keys.first;
//     }
//   }
//
//   List<AttendanceRecord> get selectedMonthRecords {
//     if (selectedMonth.value.isEmpty) return [];
//     return monthWiseRecords[selectedMonth.value] ?? [];
//   }
//
//   void changeMonth(String monthKey) {
//     selectedMonth.value = monthKey;
//   }
//
//   @override
//   void onClose() {
//     monthWiseRecords.clear();
//     super.onClose();
//   }
// }

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

  final attendanceData = Rxn<StudentAttendanceIdwiseModel>();

  /// date → record  (calendar me easy lookup ke liye)
  final attendanceMap = <DateTime, AttendanceRecord>{}.obs;

  /// All available months (sorted asc)
  final availableMonths = <DateTime>[].obs;

  /// Current focused month
  final focusedDay = DateTime.now().obs;

  /// Current month index in availableMonths
  final currentMonthIndex = 0.obs;

  // For bulk submit
  final isSubmitting = false.obs;
  final lastSubmitResponse = Rxn<StudentAttendanceCreateResponse>();

  // ─────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────
  bool get hasData => attendanceData.value != null &&
      attendanceData.value!.history.isNotEmpty;

  bool get canGoPrev => currentMonthIndex.value > 0;

  bool get canGoNext =>
      currentMonthIndex.value < availableMonths.length - 1;

  // ─────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────
  Future<void> fetchStudentAttendance(String studentCardId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getStudentAttendanceById(studentCardId);
      attendanceData.value = result;

      _prepareData(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Data preparation
  // ─────────────────────────────────────────────
  void _prepareData(StudentAttendanceIdwiseModel data) {
    attendanceMap.clear();
    availableMonths.clear();

    final history = data.history;
    if (history.isEmpty) return;

    // Year-wise loop
    history.forEach((yearStr, months) {
      final year = int.tryParse(yearStr) ?? 0;
      if (year == 0) return;

      months.forEach((monthName, records) {
        final monthNum = _monthNumber(monthName);
        final monthDate = DateTime(year, monthNum, 1);

        // Add month to available list
        availableMonths.add(monthDate);

        // Add records to map
        for (final r in records) {
          try {
            final parts = r.date.split('-'); // "2026-09-25"
            final d = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            attendanceMap[d] = r;
          } catch (_) {
            // skip invalid dates
          }
        }
      });
    });

    // Sort months ascending
    availableMonths.sort((a, b) => a.compareTo(b));

    // Default: latest month
    if (availableMonths.isNotEmpty) {
      currentMonthIndex.value = availableMonths.length - 1;
      focusedDay.value = availableMonths.last;
    }
  }

  int _monthNumber(String monthName) {
    const map = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return map[monthName] ?? 1;
  }

  // ─────────────────────────────────────────────
  // Navigation
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
  // Bulk submit
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
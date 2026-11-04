// lib/feature/school/attendance/controller/teacher_attendance_controller.dart
import 'package:get/get.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/teacher_attendance_model.dart';
import '../repository/teacher_attendance_repository.dart';

class TeacherAttendanceController extends GetxController {
  final TeacherAttendanceRepository _repository = TeacherAttendanceRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<TeacherAttendanceModel> attendanceData =
  Rxn<TeacherAttendanceModel>();

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxList<DateTime> availableMonths = <DateTime>[].obs;
  final RxInt currentMonthIndex = (-1).obs;

  bool get hasData => attendanceData.value != null;

  bool get canGoPrev =>
      availableMonths.isNotEmpty && currentMonthIndex.value > 0;

  bool get canGoNext =>
      availableMonths.isNotEmpty &&
          currentMonthIndex.value < availableMonths.length - 1;

  Map<DateTime, AttendanceRecord> get attendanceMap {
    final map = <DateTime, AttendanceRecord>{};
    if (attendanceData.value == null) return map;
    for (final record in attendanceData.value!.allRecords) {
      final normalized =
      DateTime(record.date.year, record.date.month, record.date.day);
      map[normalized] = record;
    }
    return map;
  }

  AttendanceRecord? getRecordForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return attendanceMap[normalized];
  }

  // ══════════════════════════════════════════════════════
  // Fetch — teacher id read from SharedPrefs (DB int)
  // ══════════════════════════════════════════════════════
  Future<void> fetchAttendance() async {
    final intId = await SchoolAuthSharedPrefService.getTeacherId();
    if (intId == null || intId <= 0) {
      errorMessage.value = 'Teacher ID not found. Please login again.';
      return;
    }
    final teacherId = intId.toString();

    try {
      isLoading.value = true;
      errorMessage.value = '';
      attendanceData.value = null;
      availableMonths.clear();
      currentMonthIndex.value = -1;

      final result =
      await _repository.getTeacherAttendance(teacherId: teacherId);

      attendanceData.value = result;
      _buildAvailableMonths(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void _buildAvailableMonths(TeacherAttendanceModel model) {
    final List<DateTime> months = [];
    model.history.forEach((yearStr, monthsMap) {
      final year = int.tryParse(yearStr) ?? 0;
      monthsMap.forEach((monthName, records) {
        final monthNum = _monthNameToNumber(monthName);
        if (monthNum > 0 && records.isNotEmpty) {
          months.add(DateTime(year, monthNum, 1));
        }
      });
    });
    months.sort((a, b) => a.compareTo(b));
    availableMonths.assignAll(months);

    if (months.isNotEmpty) {
      currentMonthIndex.value = months.length - 1;
      focusedDay.value = months.last;
    }
  }

  int _monthNameToNumber(String name) {
    const months = {
      'january': 1, 'february': 2, 'march': 3, 'april': 4,
      'may': 5, 'june': 6, 'july': 7, 'august': 8,
      'september': 9, 'october': 10, 'november': 11, 'december': 12,
    };
    return months[name.toLowerCase()] ?? 0;
  }

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

  Future<void> refreshAttendance() async => fetchAttendance();

  void clearError() => errorMessage.value = '';

  @override
  void onClose() {
    attendanceData.value = null;
    availableMonths.clear();
    currentMonthIndex.value = -1;
    super.onClose();
  }
}
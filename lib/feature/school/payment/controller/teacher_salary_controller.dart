// lib/feature/school/salary/controller/teacher_salary_controller.dart

import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/teacher_salary_model.dart';
import '../repository/teacher_salary_repository.dart';

class TeacherSalaryController extends GetxController {
  final TeacherSalaryRepository _repository = TeacherSalaryRepository();

  // ==================== OBSERVABLES ====================
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final Rxn<TeacherSalarySummary> summary =
  Rxn<TeacherSalarySummary>();

  // Flattened list of month cards for the current year
  final RxList<SalaryMonth> months = <SalaryMonth>[].obs;

  // Selected filters
  final RxString selectedYear = ''.obs;
  final RxString selectedMonth = 'All'.obs;
  final RxString statusFilter = 'All'.obs;

  // Pagination
  static const int _pageSize = 5;
  final RxInt visibleCount = _pageSize.obs;
  final RxBool isLoadingMore = false.obs;

  // ==================== GETTERS ====================

  /// All available years (from API, newest first)
  List<String> get availableYears {
    final list = summary.value?.years ?? [];
    return list.map((y) => y.year).toList();
  }

  /// Year object for the currently selected year
  SalaryYear? get currentYearData {
    if (summary.value == null) return null;
    final y = selectedYear.value;
    try {
      return summary.value!.years.firstWhere((e) => e.year == y);
    } catch (_) {
      return null;
    }
  }

  /// All months in selected year (before filter)
  List<SalaryMonth> get allMonths => currentYearData?.months ?? [];

  /// Months filtered by selected month + status
  List<SalaryMonth> get filteredMonths {
    var list = allMonths;

    if (selectedMonth.value != 'All') {
      list = list
          .where((m) =>
      m.month.toLowerCase() ==
          selectedMonth.value.toLowerCase())
          .toList();
    }

    if (statusFilter.value != 'All') {
      list = list.where((m) {
        // month matches if at least one record has the desired status
        return m.records.any(
              (r) =>
          r.status.toLowerCase() ==
              statusFilter.value.toLowerCase(),
        );
      }).toList();
    }

    return list;
  }

  /// Visible (paginated) months
  List<SalaryMonth> get visibleMonths =>
      filteredMonths.take(visibleCount.value).toList();

  bool get hasMore => visibleCount.value < filteredMonths.length;

  // ==================== LIFECYCLE ====================
  @override
  void onInit() {
    super.onInit();
  }

  // ==================== API CALLS ====================

  /// Load salary summary
  Future<void> fetchSalary(String teacherIdCard) async {
    try {
      isLoading.value = true;

      final data = await _repository.getSalarySummary(teacherIdCard);

      summary.value = data;

      // Auto-select latest year if nothing selected
      if (data.years.isNotEmpty) {
        if (selectedYear.value.isEmpty ||
            !data.years.any((y) => y.year == selectedYear.value)) {
          selectedYear.value = data.years.first.year;
        }
      } else {
        selectedYear.value = '';
      }

      _resetPagination();
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Save salary payment
  Future<bool> saveSalary({
    required String teacherIdCard,
    required String month,
    required String year,
    required String paymentMethod,
    required double amount,
    required double paidAmount,
    String? paidDate,
    String? remark,
  }) async {
    try {
      isSaving.value = true;

      await _repository.saveSalaryPayment(
        teacherIdCard: teacherIdCard,
        month: month,
        year: year,
        paymentMethod: paymentMethod,
        amount: amount,
        paidAmount: paidAmount,
        paidDate: paidDate,
        remark: remark,
      );

      FlutterToast.success('Salary saved successfully');

      // Refresh
      await fetchSalary(teacherIdCard);
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete entire month
  Future<bool> deleteSalaryMonth({
    required String teacherIdCard,
    required String year,
    required String month,
  }) async {
    try {
      isLoading.value = true;

      final result = await _repository.deleteSalaryMonth(
        teacherIdCard: teacherIdCard,
        year: year,
        month: month,
      );

      final count = result['deleted_count'] ?? 0;
      FlutterToast.success('Deleted $count record(s)');

      await fetchSalary(teacherIdCard);
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FILTERS ====================

  void onYearChanged(String? year) {
    if (year == null) return;
    selectedYear.value = year;
    _resetPagination();
  }

  void onMonthChanged(String? month) {
    if (month == null) return;
    selectedMonth.value = month;
    _resetPagination();
  }

  void onStatusChanged(String status) {
    statusFilter.value = status;
    _resetPagination();
  }

  void _resetPagination() {
    visibleCount.value = _pageSize;
    isLoadingMore.value = false;
  }

  // ==================== PAGINATION ====================

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;

    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 400));

    visibleCount.value =
        (visibleCount.value + _pageSize).clamp(0, filteredMonths.length);

    isLoadingMore.value = false;
  }

  Future<void> refreshData(String teacherIdCard) async {
    await fetchSalary(teacherIdCard);
  }
}
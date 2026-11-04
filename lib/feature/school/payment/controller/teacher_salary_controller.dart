// lib/feature/school/salary/controller/teacher_salary_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../../profile/controller/teacher_controller.dart';
import '../model/teacher_salary_model.dart';
import '../repository/teacher_salary_repository.dart';

class TeacherSalaryController extends GetxController {
  final TeacherSalaryRepository _repository = TeacherSalaryRepository();
  final TeacherController _teacherController = Get.find<TeacherController>();

  // ══════════════════════════════════════════════════════
  // STATE
  // ══════════════════════════════════════════════════════
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  final RxDouble _baseSalary = 0.0.obs;
  final RxDouble _totalPaidAllTime = 0.0.obs;
  final RxList<SalaryTransaction> _allTransactions =
      <SalaryTransaction>[].obs;

  // Filters
  final RxString selectedYear = ''.obs;
  final RxString selectedMonth = 'All'.obs;
  final RxString statusFilter = 'All'.obs;

  // Pagination
  static const int _pageSize = 5;
  final RxInt visibleCount = _pageSize.obs;
  final RxBool isLoadingMore = false.obs;

  // ══════════════════════════════════════════════════════
  // GETTERS
  // ══════════════════════════════════════════════════════
  double get baseSalary => _baseSalary.value;
  double get totalPaidAllTime => _totalPaidAllTime.value;

  /// Current month's total paid (sum of transactions in current month)
  double get currentMonthPaid {
    final now = DateTime.now();
    return _allTransactions
        .where((t) => t.year == now.year && t.month == now.month)
        .fold<double>(0, (s, t) => s + t.amountPaid);
  }

  /// Current month's pending amount
  double get currentMonthPending {
    return (_baseSalary.value - currentMonthPaid).clamp(0, double.infinity);
  }

  /// Latest transaction (by year desc, month desc, id desc)
  SalaryTransaction? get latestTransaction {
    if (_allTransactions.isEmpty) return null;
    final sorted = List<SalaryTransaction>.from(_allTransactions);
    sorted.sort((a, b) {
      final y = b.year.compareTo(a.year);
      if (y != 0) return y;
      final m = b.month.compareTo(a.month);
      if (m != 0) return m;
      return b.id.compareTo(a.id);
    });
    return sorted.first;
  }

  /// Distinct years from transactions, newest first
  List<String> get availableYears {
    final set = <String>{};
    for (final t in _allTransactions) {
      set.add(t.year.toString());
    }
    final list = set.toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  /// All months for the selected year (grouped)
  List<SalaryMonth> get allMonths {
    final y = int.tryParse(selectedYear.value);
    if (y == null) return [];

    final byMonth = <int, List<SalaryTransaction>>{};
    for (final t in _allTransactions) {
      if (t.year != y) continue;
      byMonth.putIfAbsent(t.month, () => []).add(t);
    }

    final groups = <SalaryMonth>[];
    byMonth.forEach((m, records) {
      final total = records.fold<double>(
          0, (s, r) => s + r.amountPaid);
      final pending = (_baseSalary.value - total).clamp(0, double.infinity);

      // Sort records inside the group newest-first
      final sortedRecords = List<SalaryTransaction>.from(records);
      sortedRecords.sort((a, b) => b.id.compareTo(a.id));

      groups.add(SalaryMonth(
        month: m,
        year: y,
        baseSalary: _baseSalary.value,
        totalPaid: total,
        pending: pending.toDouble(),
        records: sortedRecords,
      ));
    });
    groups.sort((a, b) => b.month.compareTo(a.month)); // Dec → Jan
    return groups;
  }

  /// Months after applying filters
  List<SalaryMonth> get filteredMonths {
    var list = allMonths;
    if (selectedMonth.value != 'All') {
      list = list
          .where((m) => m.monthName == selectedMonth.value)
          .toList();
    }
    if (statusFilter.value != 'All') {
      list = list
          .where((m) => m.status == statusFilter.value)
          .toList();
    }
    return list;
  }

  /// Paginated view
  List<SalaryMonth> get visibleMonths =>
      filteredMonths.take(visibleCount.value).toList();

  bool get hasMore => visibleCount.value < filteredMonths.length;

  // ══════════════════════════════════════════════════════
  // FETCH — reads teacher_id from SharedPrefs (DB int)
  // ══════════════════════════════════════════════════════
  Future<void> fetchSalary() async {
    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    if (teacherId == null || teacherId <= 0) {
      errorMessage.value =
      'Teacher ID not found. Please login again.';
      FlutterToast.error(errorMessage.value);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Base salary from teacher profile
      _baseSalary.value =
          double.tryParse(_teacherController.salary) ?? 0;

      // Transaction history
      final res =
      await _repository.getTransactionHistory(teacherId);
      _allTransactions.assignAll(res.transactions);
      _totalPaidAllTime.value = res.totalPaidAllTime;

      // Auto-select latest year
      final years = availableYears;
      if (years.isNotEmpty && !years.contains(selectedYear.value)) {
        selectedYear.value = years.first;
      } else if (years.isEmpty) {
        selectedYear.value = '';
      }

      _resetPagination();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // SAVE — create a payment
  // ══════════════════════════════════════════════════════
  Future<bool> saveSalary({
    required double amountPaid,
    required int month,
    required int year,
    String? remarks,
  }) async {
    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    if (teacherId == null || teacherId <= 0) {
      FlutterToast.error('Teacher ID not found');
      return false;
    }

    try {
      isSaving.value = true;
      await _repository.createTransaction(
        teacherId: teacherId,
        amountPaid: amountPaid,
        month: month,
        year: year,
        remarks: remarks,
      );
      FlutterToast.success('Salary payment saved');
      await fetchSalary();
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // UPDATE — edit existing transaction
  // ══════════════════════════════════════════════════════
  Future<bool> updateTransaction({
    required int transactionId,
    required double amountPaid,
    required int month,
    required int year,
    String? remarks,
  }) async {
    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    if (teacherId == null || teacherId <= 0) return false;

    try {
      isSaving.value = true;
      await _repository.updateTransaction(
        teacherId: teacherId,
        transactionId: transactionId,
        amountPaid: amountPaid,
        month: month,
        year: year,
        remarks: remarks,
      );
      FlutterToast.success('Transaction updated');
      await fetchSalary();
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // DELETE — remove transaction
  // ══════════════════════════════════════════════════════
  Future<bool> deleteTransaction(int transactionId) async {
    final teacherId = await SchoolAuthSharedPrefService.getTeacherId();
    if (teacherId == null || teacherId <= 0) return false;

    try {
      final ok = await _repository.deleteTransaction(
        teacherId: teacherId,
        transactionId: transactionId,
      );
      if (ok) {
        _allTransactions.removeWhere((t) => t.id == transactionId);
        FlutterToast.success('Transaction deleted');
      }
      return ok;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  // ══════════════════════════════════════════════════════
  // FILTERS & PAGINATION
  // ══════════════════════════════════════════════════════
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

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    visibleCount.value =
        (visibleCount.value + _pageSize).clamp(0, filteredMonths.length);
    isLoadingMore.value = false;
  }

  Future<void> refreshData() async => fetchSalary();
}
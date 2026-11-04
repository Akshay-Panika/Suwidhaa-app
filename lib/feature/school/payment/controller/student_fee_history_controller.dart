import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../model/student_fee_model.dart';
import '../repository/student_fee_repository.dart';

class StudentFeeHistoryController extends GetxController {
  final StudentFeeRepository _repository = StudentFeeRepository();

  var historyList = <FeeHistoryModel>[].obs;
  var isLoadingHistory = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;

  final RxnInt studentId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    studentId.value = await SchoolAuthSharedPrefService.getStudentId();
    if (studentId.value != null) {
      await loadHistory();
    } else {
      errorMessage.value = 'Student ID not found. Please login again.';
    }
  }

  Future<void> loadHistory() async {
    final id = studentId.value;
    if (id == null) return;

    try {
      isLoadingHistory.value = true;
      errorMessage.value = '';
      final data = await _repository.getHistory(id);
      historyList.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    final id = studentId.value;
    if (id == null) return;

    try {
      isDeleting.value = true;
      await _repository.deleteTransaction(id, transactionId);
      FlutterToast.success('Transaction deleted successfully');
      await loadHistory();
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> refresh() async {
    if (studentId.value != null) {
      await loadHistory();
    } else {
      await _bootstrap();
    }
  }

  // ============================================================
  // 🔥 NEW: Sum of all transactions (real amount paid)
  // ============================================================
  double get totalPaidFromTransactions {
    return historyList.fold(
      0.0,
          (sum, e) => sum + (double.tryParse(e.amountPaid) ?? 0.0),
    );
  }

  // ============================================================
  // 🔥 NEW: Group transactions by year (desc order)
  // ============================================================
  Map<int, List<FeeHistoryModel>> get historyByYear {
    final map = <int, List<FeeHistoryModel>>{};
    for (final item in historyList) {
      final year = _extractYear(item.paymentDate);
      map.putIfAbsent(year, () => []).add(item);
    }
    final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final k in keys) k: map[k]!};
  }

  double totalForYear(int year) {
    final list = historyByYear[year] ?? const <FeeHistoryModel>[];
    return list.fold(
      0.0,
          (sum, e) => sum + (double.tryParse(e.amountPaid) ?? 0.0),
    );
  }

  int _extractYear(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now().year;
    try {
      return DateTime.parse(dateStr).year;
    } catch (_) {
      final m = RegExp(r'(\d{4})').firstMatch(dateStr);
      return m != null ? int.parse(m.group(1)!) : DateTime.now().year;
    }
  }
}
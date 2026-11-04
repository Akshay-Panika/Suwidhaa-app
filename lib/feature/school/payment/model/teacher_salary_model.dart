// lib/feature/school/salary/model/teacher_salary_model.dart

class SalaryTransaction {
  final int id;
  final double amountPaid;
  final int month; // 1-12
  final int year;
  final String? remarks;
  final String? paymentDate;

  SalaryTransaction({
    required this.id,
    required this.amountPaid,
    required this.month,
    required this.year,
    this.remarks,
    this.paymentDate,
  });

  factory SalaryTransaction.fromJson(Map<String, dynamic> json) {
    return SalaryTransaction(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}') ?? 0,
      amountPaid: _toDouble(json['amount_paid']),
      month: json['month'] is int
          ? json['month']
          : int.tryParse('${json['month']}') ?? 0,
      year: json['year'] is int
          ? json['year']
          : int.tryParse('${json['year']}') ?? 0,
      remarks: json['remarks']?.toString(),
      paymentDate: json['payment_date']?.toString(),
    );
  }

  String get monthName => SalaryTransaction.monthNameFromNumber(month);

  static String monthNameFromNumber(int m) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    if (m < 1 || m > 12) return '';
    return names[m - 1];
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

// ═══════════════════════════════════════════════════════════
// Grouped month (computed client-side from raw transactions)
// ═══════════════════════════════════════════════════════════
class SalaryMonth {
  final int month;
  final int year;
  final double baseSalary;
  final double totalPaid;
  final double pending;
  final List<SalaryTransaction> records;

  SalaryMonth({
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.totalPaid,
    required this.pending,
    required this.records,
  });

  String get monthName => SalaryTransaction.monthNameFromNumber(month);

  bool get isPaid => pending <= 0 && totalPaid > 0;
  String get status => isPaid ? 'Paid' : 'Pending';
}

// ═══════════════════════════════════════════════════════════
// Response wrapper for history endpoint
// ═══════════════════════════════════════════════════════════
class SalaryHistoryResponse {
  final bool success;
  final int teacherId;
  final int count;
  final double totalPaidAllTime;
  final List<SalaryTransaction> transactions;

  SalaryHistoryResponse({
    required this.success,
    required this.teacherId,
    required this.count,
    required this.totalPaidAllTime,
    required this.transactions,
  });

  factory SalaryHistoryResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? [])
        .map((e) =>
        SalaryTransaction.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return SalaryHistoryResponse(
      success: json['success'] == true,
      teacherId: json['teacher_id'] is int
          ? json['teacher_id']
          : int.tryParse('${json['teacher_id']}') ?? 0,
      count: json['count'] is int ? json['count'] : list.length,
      totalPaidAllTime:
      SalaryTransaction._toDouble(json['total_paid_all_time']),
      transactions: list,
    );
  }
}
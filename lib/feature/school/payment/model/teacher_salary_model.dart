// lib/feature/school/salary/model/teacher_salary_model.dart

class TeacherSalarySummary {
  final String teacherIdCard;
  final String teacherName;
  final double totalSalary;
  final double paidAmount;
  final double pendingAmount;
  final SalaryRecord? latestSalary;
  final List<SalaryYear> years;

  TeacherSalarySummary({
    required this.teacherIdCard,
    required this.teacherName,
    required this.totalSalary,
    required this.paidAmount,
    required this.pendingAmount,
    required this.latestSalary,
    required this.years,
  });

  factory TeacherSalarySummary.fromJson(Map<String, dynamic> json) {
    return TeacherSalarySummary(
      teacherIdCard: json['teacher_id_card'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      totalSalary: _toDouble(json['total_salary']),
      paidAmount: _toDouble(json['paid_amount']),
      pendingAmount: _toDouble(json['pending_amount']),
      latestSalary: json['latest_salary'] != null
          ? SalaryRecord.fromJson(json['latest_salary'])
          : null,
      years: (json['years'] as List? ?? [])
          .map((e) => SalaryYear.fromJson(e))
          .toList(),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

class SalaryYear {
  final String year;
  final double totalSalary;
  final double paidAmount;
  final double pendingAmount;
  final List<SalaryMonth> months;

  SalaryYear({
    required this.year,
    required this.totalSalary,
    required this.paidAmount,
    required this.pendingAmount,
    required this.months,
  });

  factory SalaryYear.fromJson(Map<String, dynamic> json) {
    return SalaryYear(
      year: json['year']?.toString() ?? '',
      totalSalary: TeacherSalarySummary._toDouble(json['total_salary']),
      paidAmount: TeacherSalarySummary._toDouble(json['paid_amount']),
      pendingAmount:
      TeacherSalarySummary._toDouble(json['pending_amount']),
      months: (json['months'] as List? ?? [])
          .map((e) => SalaryMonth.fromJson(e))
          .toList(),
    );
  }
}

class SalaryMonth {
  final String month;
  final double totalSalary;
  final double paidAmount;
  final double pendingAmount;
  final List<SalaryRecord> records;

  SalaryMonth({
    required this.month,
    required this.totalSalary,
    required this.paidAmount,
    required this.pendingAmount,
    required this.records,
  });

  factory SalaryMonth.fromJson(Map<String, dynamic> json) {
    return SalaryMonth(
      month: json['month']?.toString() ?? '',
      totalSalary: TeacherSalarySummary._toDouble(json['total_salary']),
      paidAmount: TeacherSalarySummary._toDouble(json['paid_amount']),
      pendingAmount:
      TeacherSalarySummary._toDouble(json['pending_amount']),
      records: (json['records'] as List? ?? [])
          .map((e) => SalaryRecord.fromJson(e))
          .toList(),
    );
  }
}

class SalaryRecord {
  final int id;
  final String teacherIdCard;
  final String teacherName;
  final String month;
  final String year;
  final String paymentMethod;
  final double amount;
  final double paidAmount;
  final double pendingAmount;
  final String status;
  final String? paidDate;
  final String? remark;
  final String? createdAt;

  SalaryRecord({
    required this.id,
    required this.teacherIdCard,
    required this.teacherName,
    required this.month,
    required this.year,
    required this.paymentMethod,
    required this.amount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.status,
    this.paidDate,
    this.remark,
    this.createdAt,
  });

  factory SalaryRecord.fromJson(Map<String, dynamic> json) {
    return SalaryRecord(
      id: json['id'] ?? 0,
      teacherIdCard: json['teacher_id_card'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      month: json['month'] ?? '',
      year: json['year']?.toString() ?? '',
      paymentMethod: json['payment_method'] ?? '',
      amount: TeacherSalarySummary._toDouble(json['amount']),
      paidAmount: TeacherSalarySummary._toDouble(json['paid_amount']),
      pendingAmount:
      TeacherSalarySummary._toDouble(json['pending_amount']),
      status: json['status'] ?? '',
      paidDate: json['paid_date'],
      remark: json['remark'],
      createdAt: json['created_at'],
    );
  }

  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
}
// lib/feature/school/attendance/model/teacher_checkin_checkout_model.dart

class TeacherCheckInOutModel {
  final bool status;
  final String? message;
  final String? teacherId;
  final CheckInOutData? data;

  TeacherCheckInOutModel({
    required this.status,
    this.message,
    this.teacherId,
    this.data,
  });

  factory TeacherCheckInOutModel.fromJson(Map<String, dynamic> json) {
    return TeacherCheckInOutModel(
      status: json['status'] ?? false,
      message: json['message'],
      teacherId: json['teacher_id'],
      data: json['data'] != null && json['data'] is Map
          ? CheckInOutData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CheckInOutData {
  final int id;
  final DateTime date;
  final String dayName;
  final String month;
  final int year;
  final String? checkInTime;
  final String? checkOutTime;
  final String status; // PRESENT, HALF_DAY, ABSENT, etc.
  final double workingHours;
  final String? remarks;

  CheckInOutData({
    required this.id,
    required this.date,
    required this.dayName,
    required this.month,
    required this.year,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.workingHours,
    this.remarks,
  });

  factory CheckInOutData.fromJson(Map<String, dynamic> json) {
    return CheckInOutData(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      dayName: json['day_name'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? 0,
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'] ?? '',
      workingHours: (json['working_hours'] ?? 0).toDouble(),
      remarks: json['remarks'],
    );
  }

  /// Whether user has already checked-in
  bool get hasCheckedIn => checkInTime != null && checkInTime!.isNotEmpty;

  /// Whether user has already checked-out
  bool get hasCheckedOut => checkOutTime != null && checkOutTime!.isNotEmpty;
}
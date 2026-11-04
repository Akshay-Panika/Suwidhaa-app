// lib/feature/school/attendance/model/teacher_checkin_checkout_model.dart

class TeacherCheckInOutModel {
  final bool status;
  final String? message;
  final String? teacherId;
  final String? teacherIdCard;
  final CheckInOutData? data;

  TeacherCheckInOutModel({
    required this.status,
    this.message,
    this.teacherId,
    this.teacherIdCard,
    this.data,
  });

  factory TeacherCheckInOutModel.fromJson(Map<String, dynamic> json) {
    return TeacherCheckInOutModel(
      status: json['success'] == true || json['status'] == true,
      message: json['message']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      teacherIdCard: json['teacher_id_card']?.toString(),
      data: json['data'] is Map
          ? CheckInOutData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════
class CheckInOutData {
  final int? id;              // ✅ nullable — virtual records
  final DateTime date;
  final String dayName;
  final String month;
  final int year;
  final String? checkInTime;  // "09:30 AM"
  final String? checkOutTime; // "06:15 PM"
  final String status;        // present | absent | leave
  final double workingHours;
  final String? remarks;
  final bool isVirtual;       // ✅ NEW

  CheckInOutData({
    this.id,
    required this.date,
    required this.dayName,
    required this.month,
    required this.year,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.workingHours,
    this.remarks,
    this.isVirtual = false,
  });

  factory CheckInOutData.fromJson(Map<String, dynamic> json) {
    return CheckInOutData(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      date: DateTime.parse(json['date'].toString()),
      dayName: json['day_name']?.toString() ?? '',
      month: json['month']?.toString() ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse('${json['year']}') ?? 0,
      checkInTime: json['check_in_time']?.toString(),
      checkOutTime: json['check_out_time']?.toString(),
      status: json['status']?.toString() ?? 'absent',
      workingHours: (json['working_hours'] ?? 0).toDouble(),
      remarks: json['remarks']?.toString(),
      isVirtual: json['is_virtual'] == true,
    );
  }

  bool get hasCheckedIn => checkInTime != null && checkInTime!.isNotEmpty;
  bool get hasCheckedOut => checkOutTime != null && checkOutTime!.isNotEmpty;
  bool get isPresent => status.toLowerCase() == 'present';
}
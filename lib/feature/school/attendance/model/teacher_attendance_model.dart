// lib/feature/school/attendance/model/teacher_attendance_model.dart

class TeacherAttendanceModel {
  final bool status;
  final String teacherId;
  final String teacherIdCard;
  final String teacherName;
  final int totalRecords;
  final int realRecords;
  final Map<String, Map<String, List<AttendanceRecord>>> history;

  TeacherAttendanceModel({
    required this.status,
    required this.teacherId,
    required this.teacherIdCard,
    required this.teacherName,
    required this.totalRecords,
    required this.realRecords,
    required this.history,
  });

  factory TeacherAttendanceModel.fromJson(Map<String, dynamic> json) {
    final rawHistory = json['history'] as Map<String, dynamic>? ?? {};

    final Map<String, Map<String, List<AttendanceRecord>>> parsedHistory = {};

    rawHistory.forEach((year, monthsMap) {
      final Map<String, List<AttendanceRecord>> monthData = {};
      (monthsMap as Map<String, dynamic>).forEach((month, recordsList) {
        final records = (recordsList as List)
            .map((e) => AttendanceRecord.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        monthData[month] = records;
      });
      parsedHistory[year] = monthData;
    });

    return TeacherAttendanceModel(
      status: json['success'] == true,
      teacherId: json['teacher_id']?.toString() ?? '',
      teacherIdCard: json['teacher_id_card']?.toString() ?? '',
      teacherName: json['teacher_name']?.toString() ?? '',
      totalRecords: json['total_records'] ?? 0,
      realRecords: json['real_records'] ?? 0,
      history: parsedHistory,
    );
  }

  /// Flattened list of all records
  List<AttendanceRecord> get allRecords {
    final List<AttendanceRecord> records = [];
    history.forEach((_, months) {
      months.forEach((_, list) {
        records.addAll(list);
      });
    });
    return records;
  }
}

// ═══════════════════════════════════════════════════════════
class AttendanceRecord {
  final int? id;              // ✅ nullable — virtual records return null
  final DateTime date;
  final String dayName;
  final String month;
  final int year;
  final String? checkInTime;  // "09:30 AM"
  final String? checkOutTime; // "06:15 PM"
  final String status;        // present | absent | leave
  final double workingHours;
  final String? remarks;
  final bool isVirtual;       // ✅ NEW — true for auto-filled missing days

  AttendanceRecord({
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

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
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

  /// ✅ Backend only supports these three
  AttendanceStatusType get statusType {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatusType.present;
      case 'leave':
        return AttendanceStatusType.leave;
      case 'absent':
      default:
        return AttendanceStatusType.absent;
    }
  }

  bool get hasCheckedIn => checkInTime != null && checkInTime!.isNotEmpty;
  bool get hasCheckedOut => checkOutTime != null && checkOutTime!.isNotEmpty;
}

// ═══════════════════════════════════════════════════════════
enum AttendanceStatusType {
  present,
  absent,
  leave,
}
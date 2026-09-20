// lib/feature/school/attendance/model/teacher_attendance_model.dart

class TeacherAttendanceModel {
  final bool status;
  final String teacherId;
  final int totalRecords;
  final Map<String, Map<String, List<AttendanceRecord>>> history;

  TeacherAttendanceModel({
    required this.status,
    required this.teacherId,
    required this.totalRecords,
    required this.history,
  });

  factory TeacherAttendanceModel.fromJson(Map<String, dynamic> json) {
    final rawHistory = json['history'] as Map<String, dynamic>? ?? {};

    final Map<String, Map<String, List<AttendanceRecord>>> parsedHistory = {};

    rawHistory.forEach((year, monthsMap) {
      final Map<String, List<AttendanceRecord>> monthData = {};
      (monthsMap as Map<String, dynamic>).forEach((month, recordsList) {
        final records = (recordsList as List)
            .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
            .toList();
        monthData[month] = records;
      });
      parsedHistory[year] = monthData;
    });

    return TeacherAttendanceModel(
      status: json['status'] ?? false,
      teacherId: json['teacher_id'] ?? '',
      totalRecords: json['total_records'] ?? 0,
      history: parsedHistory,
    );
  }

  /// Get all records flattened
  List<AttendanceRecord> get allRecords {
    final List<AttendanceRecord> records = [];
    history.forEach((year, months) {
      months.forEach((month, list) {
        records.addAll(list);
      });
    });
    return records;
  }
}

class AttendanceRecord {
  final int id;
  final DateTime date;
  final String dayName;
  final String? checkInTime;
  final String? checkOutTime;
  final String status; // PRESENT, ABSENT, HALF_DAY, LEAVE, WEEK_OFF, RUNNING
  final double workingHours;
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.dayName,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.workingHours,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      dayName: json['day_name'] ?? '',
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'] ?? '',
      workingHours: (json['working_hours'] ?? 0).toDouble(),
      remarks: json['remarks'],
    );
  }

  /// Map API status to UI enum
  AttendanceStatusType get statusType {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return AttendanceStatusType.present;
      case 'ABSENT':
        return AttendanceStatusType.absent;
      case 'HALF_DAY':
        return AttendanceStatusType.halfDay;
      case 'LEAVE':
        return AttendanceStatusType.leave;
      case 'WEEK_OFF':
        return AttendanceStatusType.weekOff;
      case 'RUNNING':
        return AttendanceStatusType.running;
      default:
        return AttendanceStatusType.absent;
    }
  }
}

enum AttendanceStatusType {
  weekOff,
  absent,
  present,
  running,
  halfDay,
  leave,
}
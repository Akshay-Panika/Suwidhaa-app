// lib/model/student_attendance_idwise_model.dart

class StudentAttendanceIdwiseModel {
  final bool status;
  final String studentCardId;
  final String studentName;
  final String studentClass;
  final String schoolType;
  final int totalRecords;
  final Map<String, Map<String, List<AttendanceRecord>>> history;

  StudentAttendanceIdwiseModel({
    required this.status,
    required this.studentCardId,
    required this.studentName,
    required this.studentClass,
    required this.schoolType,
    required this.totalRecords,
    required this.history,
  });

  factory StudentAttendanceIdwiseModel.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, List<AttendanceRecord>>> parsedHistory = {};

    if (json['history'] != null) {
      final historyMap = json['history'] as Map<String, dynamic>;
      historyMap.forEach((year, months) {
        final monthMap = <String, List<AttendanceRecord>>{};
        (months as Map<String, dynamic>).forEach((month, records) {
          monthMap[month] = (records as List)
              .map((e) => AttendanceRecord.fromJson(e))
              .toList();
        });
        parsedHistory[year] = monthMap;
      });
    }

    return StudentAttendanceIdwiseModel(
      status: json['status'] ?? false,
      studentCardId: json['student_card_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      schoolType: json['school_type'] ?? '',
      totalRecords: json['total_records'] ?? 0,
      history: parsedHistory,
    );
  }
}

class AttendanceRecord {
  final int id;
  final String date;
  final String dayName;
  final String month;
  final int year;
  final String attendanceStatus;
  final String remarks;
  final String createdAt;
  final String updatedAt;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.dayName,
    required this.month,
    required this.year,
    required this.attendanceStatus,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? 0,
      attendanceStatus: json['attendance_status'] ?? '',
      remarks: json['remarks'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isPresent => attendanceStatus.toLowerCase() == 'present';
}


// lib/feature/student_attendance/model/student_attendance_create_model.dart

class StudentAttendanceCreateRequest {
  final List<StudentAttendanceItem> students;

  StudentAttendanceCreateRequest({required this.students});

  Map<String, dynamic> toJson() => {
    "students": students.map((e) => e.toJson()).toList(),
  };
}

class StudentAttendanceItem {
  final String studentCardId;
  final String studentName;
  final String studentClass;
  final String schoolType;
  final String date; // "YYYY-MM-DD"
  final String attendanceStatus; // present | absent | leave
  final String remarks;

  StudentAttendanceItem({
    required this.studentCardId,
    required this.studentName,
    required this.studentClass,
    required this.schoolType,
    required this.date,
    required this.attendanceStatus,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
    "student_card_id": studentCardId,
    "student_name": studentName,
    "student_class": studentClass,
    "school_type": schoolType,
    "date": date,
    "attendance_status": attendanceStatus.toLowerCase(),
    "remarks": remarks,
  };
}

// ============ RESPONSE ============
class StudentAttendanceCreateResponse {
  final bool status;
  final String message;
  final int total;
  final List<StudentAttendanceResult> data;

  StudentAttendanceCreateResponse({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  factory StudentAttendanceCreateResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceCreateResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => StudentAttendanceResult.fromJson(e))
          .toList(),
    );
  }
}

class StudentAttendanceResult {
  final int id;
  final String studentCardId;
  final String studentName;
  final String studentClass;
  final String schoolType;
  final String date;
  final String dayName;
  final String attendanceStatus;
  final String remarks;

  StudentAttendanceResult({
    required this.id,
    required this.studentCardId,
    required this.studentName,
    required this.studentClass,
    required this.schoolType,
    required this.date,
    required this.dayName,
    required this.attendanceStatus,
    required this.remarks,
  });

  factory StudentAttendanceResult.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResult(
      id: json['id'] ?? 0,
      studentCardId: json['student_card_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      schoolType: json['school_type'] ?? '',
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      attendanceStatus: json['attendance_status'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
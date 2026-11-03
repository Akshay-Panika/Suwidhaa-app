// lib/feature/school/attendance/model/student_attendance_model.dart

// ==================== SCHOOL INFO ====================
class AttendanceSchoolInfo {
  final int id;
  final String schoolName;
  final String schoolCode;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final String email;
  final String website;
  final String board;
  final String schoolType;

  AttendanceSchoolInfo({
    required this.id,
    required this.schoolName,
    required this.schoolCode,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.email,
    required this.website,
    required this.board,
    required this.schoolType,
  });

  factory AttendanceSchoolInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceSchoolInfo(
      id: json['id'] ?? 0,
      schoolName: json['school_name'] ?? '',
      schoolCode: json['school_code'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      board: json['board'] ?? '',
      schoolType: json['school_type'] ?? '',
    );
  }

  String get fullAddress {
    final parts = [address, city, state, pincode]
        .where((e) => e.isNotEmpty && e != 'null')
        .toList();
    return parts.join(', ');
  }
}

// ==================== STUDENT INFO ====================
class AttendanceStudentInfo {
  final int id;
  final String studentProfile;
  final AttendanceSchoolInfo? school;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String gender;
  final String fatherName;
  final String motherName;
  final String parentPhone;
  final String alternativePhone;
  final String adharNumber;
  final String sssmid;
  final String studentClass;
  final String rollNumber;
  final String address;
  final String casteCategory;
  final String feeStatus;
  final String feeAmount;
  final String paidAmount;
  final bool checkBox;
  final String studentIdCard;
  final String createdAt;
  final String updatedAt;

  AttendanceStudentInfo({
    required this.id,
    required this.studentProfile,
    this.school,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.fatherName,
    required this.motherName,
    required this.parentPhone,
    required this.alternativePhone,
    required this.adharNumber,
    required this.sssmid,
    required this.studentClass,
    required this.rollNumber,
    required this.address,
    required this.casteCategory,
    required this.feeStatus,
    required this.feeAmount,
    required this.paidAmount,
    required this.checkBox,
    required this.studentIdCard,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceStudentInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceStudentInfo(
      id: json['id'] ?? 0,
      studentProfile: json['student_profile'] ?? '',
      school: json['school'] is Map
          ? AttendanceSchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null,
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      parentPhone: json['parent_phone'] ?? '',
      alternativePhone: json['alternative_phone'] ?? '',
      adharNumber: json['adhar_number'] ?? '',
      sssmid: json['SSSMID'] ?? '',
      studentClass: json['student_class'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      address: json['address'] ?? '',
      casteCategory: json['caste_category'] ?? '',
      feeStatus: json['fee_status'] ?? '',
      feeAmount: json['fee_amount'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      checkBox: json['check_box'] ?? false,
      studentIdCard: json['student_id_card'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get fullName => '$firstName $middleName $lastName'.trim();
  double get remainingFee => (double.tryParse(feeAmount) ?? 0) - (double.tryParse(paidAmount) ?? 0);
}

// ==================== ATTENDANCE RECORD ====================
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

// ==================== MAIN MODEL (Single Student Detail) ====================
class StudentAttendanceIdwiseModel {
  final bool status;
  final AttendanceStudentInfo? student;
  final int totalRecords;
  final Map<String, Map<String, List<AttendanceRecord>>> history;

  StudentAttendanceIdwiseModel({
    required this.status,
    this.student,
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
      student: json['student'] is Map
          ? AttendanceStudentInfo.fromJson(Map<String, dynamic>.from(json['student']))
          : null,
      totalRecords: json['total_records'] ?? 0,
      history: parsedHistory,
    );
  }
}

// ==================== TODAY'S ATTENDANCE MODEL ====================
class TodayAttendanceModel {
  final bool status;
  final String message;
  final AttendanceRecord? attendance;
  final String date;
  final String dayName;

  TodayAttendanceModel({
    required this.status,
    this.message = '',
    this.attendance,
    this.date = '',
    this.dayName = '',
  });

  factory TodayAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      attendance: json['attendance'] != null && json['attendance'] is Map
          ? AttendanceRecord.fromJson(Map<String, dynamic>.from(json['attendance']))
          : null,
    );
  }
}

// ==================== BULK CREATE REQUEST ====================
class StudentAttendanceItem {
  final int studentId; // ✅ Backend 'student_id' (int) maang raha hai
  final String date; // "YYYY-MM-DD"
  final String attendanceStatus; // present | absent | leave
  final String remarks;

  StudentAttendanceItem({
    required this.studentId,
    required this.date,
    required this.attendanceStatus,
    this.remarks = '',
  });

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "date": date,
    "attendance_status": attendanceStatus.toLowerCase(),
    "remarks": remarks,
  };
}

// ==================== BULK CREATE RESPONSE ====================
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
  final Map<String, dynamic> student;
  final Map<String, dynamic> attendance;

  StudentAttendanceResult({
    required this.student,
    required this.attendance,
  });

  factory StudentAttendanceResult.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResult(
      student: Map<String, dynamic>.from(json['student'] ?? {}),
      attendance: Map<String, dynamic>.from(json['attendance'] ?? {}),
    );
  }
}